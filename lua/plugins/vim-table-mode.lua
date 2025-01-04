-- https://github.com/dhruvasagar/vim-table-mode
-- https://github.com/dhruvasagar/vim-table-mode/issues/236
return {
  'dhruvasagar/vim-table-mode',
  ft = 'markdown',
  init = function()
    -- Avoid polluting <leader>t mappings. (keep <leader>tm for enable)
    vim.g.table_mode_disable_tableize_mappings = 1

    -- FIX: Really slow performance: https://github.com/dhruvasagar/vim-table-mode/issues/227

    vim.g.table_mode_syntax = 0

    vim.g.table_mode_corner = '|'
  end,
}
