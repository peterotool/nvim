-- TODO: add Keympas
-- https://github.com/obsidian-nvim/obsidian.nvim/wiki/Keymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  once = true,
  callback = function()
    vim.pack.add {
      'https://github.com/nvim-lua/plenary.nvim',
      'https://github.com/epwalsh/obsidian.nvim',
    }

    require('obsidian').setup {
      workspaces = {
        {
          name = 'brain',
          path = '~/Code/gists',
        },
      },
      ui = {

        -- disable concealed text (texto oculto)
        enable = false,
      },
      checkbox = {
        enabled = true,
        create_new = false,
      },
      -- Remove Obsidian's default (Smart Action) <CR> mapping in markdown buffers
      -- verbose nmap <CR>

      mappings = {},
    }
  end,
})
