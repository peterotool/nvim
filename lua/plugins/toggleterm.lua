-- https://www.youtube.com/watch?v=5J_LiNTdqYQ
-- https://github.com/pojokcodeid/neovim-tutorial/blob/main/lua/plugins/toggleterm.lua
vim.pack.add {
  'https://github.com/akinsho/toggleterm.nvim',
}

require('toggleterm').setup {
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
}

-- Terminal buffer keymaps
local terminal_group = vim.api.nvim_create_augroup('toggleterm-keymaps', { clear = true })

vim.api.nvim_create_autocmd('TermOpen', {
  group = terminal_group,
  pattern = 'term://*',
  callback = function()
    local opts = { buffer = 0 }

    vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  end,
})

-- Send code to terminal
vim.keymap.set('n', '<leader>tsl', '<cmd>ToggleTermSendCurrentLine<cr>', { desc = 'Terminal: send line' })
vim.keymap.set('x', '<leader>tsv', '<cmd>ToggleTermSendVisualLines<cr>', { desc = 'Terminal: send visual lines' })
vim.keymap.set('x', '<leader>tsb', '<cmd>ToggleTermSendVisualSelection<cr>', { desc = 'Terminal: send block text' })

-- Terminal toggles
vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', { desc = 'Terminal: float' })
vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTermToggleAll!<cr>', { desc = 'Terminal: toggle all' })
vim.keymap.set('n', '<leader>th', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', { desc = 'Terminal: horizontal' })
vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', { desc = 'Terminal: vertical' })
