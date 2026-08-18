vim.pack.add {
  { src = 'https://github.com/sindrets/diffview.nvim' },
}

vim.keymap.set('n', '<leader>do', '<cmd>DiffviewOpen<cr>', { desc = 'Open Diffview' })

vim.keymap.set('n', '<leader>dc', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' })
