vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  once = true,
  callback = function()
    vim.pack.add {
      'https://github.com/dhruvasagar/vim-table-mode',
    }

    -- Keep the visual table styling
    vim.g.table_mode_syntax = 1

    -- Prevent extra default mappings if you do not want them
    vim.g.table_mode_disable_tableize_mappings = 1

    -- Markdown-friendly pipe corner
    vim.g.table_mode_corner = '|'

    -- Manual realign mapping
    vim.keymap.set('n', '<leader>ta', '<cmd>TableModeRealign<CR>', {
      silent = true,
      desc = 'Realign table',
      buffer = true,
    })
  end,
})
