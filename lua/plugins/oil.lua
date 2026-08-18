vim.pack.add {
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/refractalize/oil-git-status.nvim',
}

require('oil').setup {
  columns = { 'icon' },

  keymaps = {
    ['<C-h>'] = false,
    ['<C-l>'] = false,
    ['<C-r>'] = 'actions.refresh',
    ['<M-h>'] = 'actions.select_split',
  },

  view_options = {
    show_hidden = true,
  },
  win_options = {
    signcolumn = 'yes:2',
  },
}

require('oil-git-status').setup()

vim.keymap.set('n', '-', '<CMD>Oil<CR>', {
  desc = 'Open parent directory in current window',
})

vim.keymap.set('n', '<space>-', require('oil').toggle_float, {
  desc = 'Open parent directory in floating window',
})
