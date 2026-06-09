-- https://github.com/epwalsh/obsidian.nvim

-- TODO: add Keympas
-- https://github.com/obsidian-nvim/obsidian.nvim/wiki/Keymaps
return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'brain',
        path = '~/Code/gists',
      },
    },

    ui = {
      enable = true,
    },

    checkbox = {
      enabled = true,
      create_new = false,
    },

    -- Remove Obsidian's default (Smart Action) <CR> mapping in markdown buffers
    -- verbose nmap <CR>
    mappings = {},
  },
}
