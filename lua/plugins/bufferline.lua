-- https://github.com/akinsho/bufferline.nvim
-- It renders:
--   - buffer tabs
--   - icons
--   - close buttons (❌)
return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',

  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        diagnostics = 'nvim_lsp',
        separator_style = 'slant',

        -- 🖱️ Click ❌ → bufferline → your function → buffer gets deleted
        close_command = function(n)
          require('mini.bufremove').delete(n, false)
        end,
        right_mouse_command = function(n)
          require('mini.bufremove').delete(n, false)
        end,
      },
    }
  end,
}
