vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
}

require('neo-tree').setup {
  filesystem = {
    follow_current_file = {
      enabled = true,
    },
    hijack_netrw_behavior = 'open_default',
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
  window = {
    preview = {
      use_float = false,
      use_image_nvim = false,
    },
  },
}

vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<CR>', { desc = 'Toggle Neo-tree' })

vim.keymap.set('n', '<leader>fe', '<cmd>Neotree focus<CR>', { desc = 'Focus Neo-tree' })
