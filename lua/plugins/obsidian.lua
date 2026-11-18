local obsidian_group = vim.api.nvim_create_augroup('obsidian-markdown', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = obsidian_group,
  pattern = 'markdown',
  callback = function(args)
    if vim.bo[args.buf].buftype ~= '' then
      return
    end

    if not vim.g.obsidian_setup then
      vim.pack.add {
        {
          src = 'https://github.com/obsidian-nvim/obsidian.nvim',
          version = vim.version.range '*',
        },
        'https://github.com/nvim-lua/plenary.nvim',
        'https://github.com/nvim-telescope/telescope.nvim',
      }

      require('obsidian').setup {
        legacy_commands = false,
        workspaces = {
          {
            name = 'brain',
            path = '~/Code/gists',
          },
        },
        picker = {
          name = 'telescope.nvim',
        },
        ui = {
          enable = false,
        },
        checkbox = {
          enabled = true,
          create_new = false,
        },
        mappings = {},
      }

      vim.g.obsidian_setup = true
    end

    local function map(lhs, command, desc)
      vim.keymap.set('n', lhs, '<cmd>' .. command .. '<CR>', {
        buffer = args.buf,
        silent = true,
        desc = desc,
      })
    end

    map('<leader>ob', 'ObsidianBacklinks', 'Obsidian backlinks')
    map('<leader>od', 'ObsidianToday', 'Obsidian daily note')
    map('<leader>ol', 'ObsidianLinks', 'Obsidian note links')
    map('<leader>oo', 'ObsidianOpen', 'Open in Obsidian')
    map('<leader>oq', 'ObsidianQuickSwitch', 'Obsidian quick switch')
    map('<leader>os', 'ObsidianSearch', 'Search Obsidian notes')
    map('<leader>ot', 'ObsidianTemplate', 'Insert Obsidian template')
    map('<leader>oT', 'ObsidianTOC', 'Obsidian table of contents')
  end,
})
