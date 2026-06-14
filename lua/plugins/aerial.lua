vim.pack.add {
  { src = 'https://github.com/stevearc/aerial.nvim' },
}

require('aerial').setup {
  on_attach = function(bufnr)
    vim.keymap.set('n', '<', '<cmd>AerialPrev<CR>', { buffer = bufnr, desc = 'Aerial Previous Symbol' })

    vim.keymap.set('n', '>', '<cmd>AerialNext<CR>', { buffer = bufnr, desc = 'Aerial Next Symbol' })
  end,

  layout = {
    min_width = 30,
  },
}

vim.keymap.set('n', '<leader>o', '<cmd>AerialToggle!<CR>', { desc = 'Toggle Aerial' })

vim.keymap.set('n', '<leader>on', '<cmd>AerialNavToggle<CR>', { desc = 'Toggle Aerial Navigation' })
