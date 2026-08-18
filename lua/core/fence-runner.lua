-- Most languages: the temp file is appended at the end of the command.
-- Rust: uses %s as a placeholder because it needs two steps
-- (compile with rustc, then execute the resulting binary).
-- Python is handled separately by resolve_python() below.
local runners = {
  lua = 'lua',
  bash = 'bash',
  sh = 'sh',
  zsh = 'zsh',
  javascript = 'node',
  js = 'node',
  ruby = 'ruby',
  php = 'php',
  r = 'Rscript',
  go = 'go run',
  rust = 'rustc %s -o /tmp/__nvim_fence_rs 2>&1 && /tmp/__nvim_fence_rs',
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

-- Collects all fences of the same language that appear BEFORE stop_line.
-- Lets the current block access classes/functions defined in previous blocks.
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

  return #blocks > 0 and table.concat(blocks, '\n\n') or nil
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

  -- Prepend preceding fences of the same language so the current block
  -- can access classes/functions defined in earlier blocks.
  local preceding = collect_preceding_fences(lang, fence_line)
  local full_code = preceding and (preceding .. '\n\n' .. code) or code

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
