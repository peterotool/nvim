-- Python is handled separately by resolve_python() below.
local runners = {
  lua = 'lua',
  bash = 'bash',
  sh = 'sh',
  zsh = 'zsh',
  javascript = 'node',
  js = 'node',
  php = 'php',
  r = 'Rscript',
}

-- For Python: search for a virtualenv before falling back to system python.
-- Looks for .venv, venv, or env folders in the buffer's directory and cwd.
local function resolve_python()
  local candidates = { '.venv', 'venv', 'env' }
  local search_dirs = {
    vim.fn.expand '%:p:h', -- directory of the current file
    vim.fn.getcwd(), -- project root (cwd)
  }
  for _, dir in ipairs(search_dirs) do
    for _, name in ipairs(candidates) do
      local bin = dir .. '/' .. name .. '/bin/python'
      if vim.fn.executable(bin) == 1 then
        return bin
      end
    end
  end
  return 'python3' -- system fallback
end

-- Scans the buffer line by line to find the fence that contains the cursor.
-- Returns (lang, code, fence_start_line) or nil if the cursor is outside any fence.
local function get_fence_at_cursor()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cursor = vim.api.nvim_win_get_cursor(0)[1]
  local lang, code_start, fence_start, in_fence = nil, nil, nil, false

  for i, line in ipairs(lines) do
    local fence_lang = line:match '^```(%w+)' -- opening: ```python, ```go, etc.
    if fence_lang and not in_fence then
      in_fence, fence_start, lang, code_start = true, i, fence_lang, i + 1
    elseif line:match '^```%s*$' and in_fence then -- closing: ``` alone
      if cursor >= fence_start and cursor <= i then
        local code = {}
        for j = code_start, i - 1 do
          table.insert(code, lines[j])
        end
        return lang, table.concat(code, '\n'), fence_start -- fence_start needed to know where to stop
      end
      in_fence, lang, code_start, fence_start = false, nil, nil, nil
    end
  end
end

-- Per-language wrappers applied to each preceding fence.
-- Suppress stdout/stderr so earlier print/echo/console.log calls don't leak
-- into the current fence's output, while still making definitions available.
local preceding_wrappers = {
  python = function(code)
    local indented = '    ' .. code:gsub('\n', '\n    ')
    return table.concat({
      'import sys as __sys, io as __io',
      '__stdout, __stderr = __sys.stdout, __sys.stderr',
      '__sys.stdout = __sys.stderr = __io.StringIO()',
      'try:',
      indented,
      'except Exception:',
      '    pass',
      'finally:',
      '    __sys.stdout, __sys.stderr = __stdout, __stderr',
    }, '\n')
  end,

  lua = function(code)
    return table.concat({
      'local __print = print; print = function() end',
      'pcall(function()',
      code,
      'end)',
      'print = __print',
    }, '\n')
  end,

  -- Bash/sh/zsh: run the block in a subshell redirected to /dev/null
  bash = function(code)
    return '( ' .. code .. ' ) >/dev/null 2>&1 || true'
  end,

  javascript = function(code)
    return table.concat({
      ';(function(){',
      '  const _l=console.log,_e=console.error,_w=console.warn;',
      '  console.log=console.error=console.warn=()=>{};',
      '  try{',
      '    ' .. code:gsub('\n', '\n    '),
      '  }catch(e){}',
      '  console.log=_l;console.error=_e;console.warn=_w;',
      '})();',
    }, '\n')
  end,

  r = function(code)
    return table.concat({
      'local({',
      '  con <- textConnection(character(), "w")',
      '  sink(con); sink(con, type="message")',
      '  tryCatch({' .. code .. '}, error=function(e){})',
      '  sink(); sink(type="message")',
      '})',
    }, '\n')
  end,
}
preceding_wrappers.python3 = preceding_wrappers.python
preceding_wrappers.sh = preceding_wrappers.bash
preceding_wrappers.zsh = preceding_wrappers.bash
preceding_wrappers.js = preceding_wrappers.javascript

-- Scans the buffer for all fences in `lang` that close before `stop_line`
-- (the opening line of the fence the user is running). Returns them as a list
-- of raw code strings — one entry per fence — so run_fence can apply a
-- language-specific output-suppression wrapper to each one individually before
-- concatenating them with the current block.
local function collect_preceding_fences(lang, stop_line)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local blocks = {}
  local in_fence, fence_lang, code_start = false, nil, nil

  for i, line in ipairs(lines) do
    if i >= stop_line then
      break
    end
    local fl = line:match '^```(%w+)'
    if fl and not in_fence then
      in_fence, fence_lang, code_start = true, fl, i + 1
    elseif line:match '^```%s*$' and in_fence then
      if fence_lang:lower() == lang:lower() then
        local block = {}
        for j = code_start, i - 1 do
          table.insert(block, lines[j])
        end
        table.insert(blocks, table.concat(block, '\n'))
      end
      in_fence, fence_lang, code_start = false, nil, nil
    end
  end

  return blocks
end

local function run_fence()
  local lang, code, fence_line = get_fence_at_cursor()
  if not lang then
    vim.notify('Cursor is not inside a code fence', vim.log.levels.WARN)
    return
  end

  -- Resolve runner: Python gets venv-aware resolution; everything else hits the table.
  local lang_key = lang:lower()
  local runner
  if lang_key == 'python' or lang_key == 'python3' then
    runner = resolve_python()
  else
    runner = runners[lang_key]
  end

  if not runner then
    vim.notify('No runner configured for: ' .. lang, vim.log.levels.WARN)
    return
  end

  -- Prepend preceding fences wrapped in try/except so their exceptions
  -- never prevent the current fence from running.
  local blocks = collect_preceding_fences(lang, fence_line)
  local wrap = preceding_wrappers[lang_key]
  local parts = {}
  for _, block in ipairs(blocks) do
    table.insert(parts, wrap and wrap(block) or block)
  end
  table.insert(parts, code)
  local full_code = table.concat(parts, '\n\n')

  -- Write code to a temp file with the correct extension so the interpreter
  -- recognizes it (e.g. rustc requires .rs).
  local tmpfile = vim.fn.tempname() .. '.' .. lang
  local f = assert(io.open(tmpfile, 'w'))
  f:write(full_code)
  f:close()

  -- If the runner contains %s, use it as a template (Rust: compile + run).
  -- Otherwise, simply append the file at the end of the command.
  local cmd = runner:find '%%s' and runner:format(tmpfile) or (runner .. ' ' .. vim.fn.shellescape(tmpfile))
  local output = vim.fn.system(cmd)
  os.remove(tmpfile)

  -- Open a bottom split with the output (does not overlap the original code)
  local out_lines = vim.split(vim.trim(output), '\n', { plain = true })
  local buf = vim.api.nvim_create_buf(false, true) -- unlisted scratch buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, out_lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = 'wipe' -- auto-cleanup when the window is closed

  local h25 = math.floor(vim.o.lines * 0.25)
  local h50 = math.floor(vim.o.lines * 0.50)

  vim.cmd('botright ' .. h25 .. 'split')
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)

  -- Strip unnecessary decorations from the output window
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = 'no'
  vim.wo[win].statusline = ' ' .. lang .. ' output  (= to expand)'

  -- Close the split with q or Escape (scoped to this buffer only)
  for _, key in ipairs { 'q', '<Esc>' } do
    vim.keymap.set('n', key, '<cmd>close<cr>', { buffer = buf, silent = true })
  end

  -- = toggles between 25% and 50% of the viewport
  local expanded = false
  vim.keymap.set('n', '=', function()
    expanded = not expanded
    vim.api.nvim_win_set_height(win, expanded and h50 or h25)
  end, { buffer = buf, silent = true })
end

-- Generic mapping: works from normal, visual, and insert mode
vim.keymap.set({ 'n', 'v', 'i' }, '<leader>r', run_fence, {
  desc = 'Run code fence under cursor',
})
