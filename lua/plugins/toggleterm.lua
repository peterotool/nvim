-- https://github.com/akinsho/toggleterm.nvim
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
  end,

  keys = {
    -- Send code to terminal
    { '<leader>tsl', '<cmd>ToggleTermSendCurrentLine<cr>', desc = 'Terminal: send line', mode = 'n' },
    { '<leader>tsv', '<cmd>ToggleTermSendVisualLines<cr>', desc = 'Terminal: send visual lines', mode = 'x' },
    { '<leader>tsb', '<cmd>ToggleTermSendBracketedPaste<cr>', desc = 'Terminal: send block text', mode = 'x' },

    -- Terminal group (which-key)
    { '<leader>t', '', desc = ' Terminal', mode = 'n' },

    -- Terminal toggles
    { '<leader>tt', '<cmd>ToggleTermToggleAll!<cr>', desc = 'Terminal: toggle all', mode = 'n' },
    { '<leader>th', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'Terminal: horizontal', mode = 'n' },
    { '<leader>tv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Terminal: vertical', mode = 'n' },
  },
}
