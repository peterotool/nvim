vim.pack.add {
  'https://github.com/nathom/tmux.nvim',
}

local tmux = require 'tmux'

vim.keymap.set('n', '<C-h>', tmux.move_left, { desc = 'Go left tmux window' })
vim.keymap.set('n', '<C-j>', tmux.move_down, { desc = 'Go down tmux window' })
vim.keymap.set('n', '<C-k>', tmux.move_up, { desc = 'Go up tmux window' })
vim.keymap.set('n', '<C-l>', tmux.move_right, { desc = 'Go right tmux window' })
