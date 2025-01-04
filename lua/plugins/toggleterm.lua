-- toggleterm provides a terminal in vim you can send code to
-- https://www.youtube.com/watch?v=5J_LiNTdqYQ
-- https://github.com/pojokcodeid/neovim-tutorial/blob/main/lua/plugins/toggleterm.lua

return {
  'akinsho/toggleterm.nvim',
  lazy = true,
  cmd = {
    'ToggleTerm',
    'TermExec',
    'ToggleTermToggleAll',
    'ToggleTermSendCurrentLine',
    'ToggleTermSendVisualLines',
    'ToggleTermSendVisualSelection',
  },
  branch = 'main',
  opts = {
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = 'float',
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = 'curved',
      winblend = 0,
      highlights = {
        border = 'Normal',
        background = 'Normal',
      },
    },
  },
  config = function(_, opts)
    require('toggleterm').setup(opts)
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end
    vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'
    -- https://daler.github.io/dotfiles/vim.html#toggleterm
    local function is_whitespace(str)
      return str:match '^%s*$' ~= nil
    end

    -- Function to remove leading and ending whitespace strings
    local function trim_whitespace_strings(lines)
      local start_idx, end_idx = 1, #lines

      -- Find the index of the first non-whitespace string
      while start_idx <= #lines and is_whitespace(lines[start_idx]) do
        start_idx = start_idx + 1
      end

      -- Find the index of the last non-whitespace string
      while end_idx >= 1 and is_whitespace(lines[end_idx]) do
        end_idx = end_idx - 1
      end

      -- Create a new table containing only the non-whitespace strings
      local trimmed_lines = {}
      for i = start_idx, end_idx do
        table.insert(trimmed_lines, lines[i])
      end

      return trimmed_lines
    end

    local M = {}

    function M.send_lines_to_ipython()
      local id = 1

      local current_window = vim.api.nvim_get_current_win() -- save current window

      local vstart = vim.fn.getpos "'<"
      local vend = vim.fn.getpos "'>"
      local line_start = vstart[2]
      local line_end = vend[2]
      local lines = vim.fn.getline(line_start, line_end)
      --
      local cmd = string.char(15)

      for _, line in ipairs(trim_whitespace_strings(lines)) do
        local l = line
        if l == '' then
          cmd = cmd .. string.char(15) .. string.char(14)
        else
          cmd = cmd .. l .. string.char(10)
        end
      end
      cmd = cmd .. string.char(4)
      require('toggleterm').exec(cmd, id)

      vim.api.nvim_set_current_win(current_window)
    end
  end,
  -- Patch toggleterm to use bracketed paste (special escape codes before
  -- and after the text to be pasted)
  -- https://en.wikipedia.org/wiki/Bracketed-paste
  -- https://cirw.in/blog/bracketed-paste
  vim.api.nvim_create_user_command('ToggleTermSendBracketedPaste', function(args)
    require('toggleterm').exec('\x1b[200~', 1)
    require('toggleterm').send_lines_to_terminal('visual_selection', false, args)
    require('toggleterm').exec('\x1b[201~', 1)
  end, { range = true, nargs = '?' }),
  keys = {
    { 'gxx', ':ToggleTermSendCurrentLine<CR><CR>', desc = 'Send current line to terminal' },
    { 'gx', ':ToggleTermSendBracketedPaste<CR><CR>', desc = 'Send selection to terminal', mode = 'x' },
    { '<leader>tx', '<cmd>ToggleTermToggleAll!<cr>', desc = 'Toggle [T]erminals', mode = 'n' }, --Close Tab
    { '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Toggle [F]loat [T]erminal', mode = 'n' },
    { '<leader>th', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'Toggle [H]orizontal [T]erminal', mode = 'n' },
    { '<leader>tv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Toggle [V]ertical [T]erminal', mode = 'n' },
    { '<leader>ts', '<cmd>ToggleTerm direction=tab<cr>', desc = 'Toggle [T]ab [T]erminal', mode = 'n' },
    { '<leader>tl', '<cmd>ToggleTermSendVisualLines<cr>', desc = 'Send lines to Python interpreter', mode = 'x' },
    { '<leader>tr', ":'<,'>lua require('plugins.toggleterm').send_lines_to_ipython()<cr>", mode = 'v', desc = 'Send selection to IPython' },
  },
}
