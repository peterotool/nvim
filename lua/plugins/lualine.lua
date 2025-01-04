-- https://github.com/n vim-lualine/lualine.nvim
return {
  'nvim-lualine/lualine.nvim',
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_c = {
          {
            require('lazy.status').updates,
            cond = require('lazy.status').has_updates,
          },
          {
            'filename',
            -- file_status = true, -- displays file status (readonly status, modified status)
            path = 3, -- 0: Just the filename
            -- 1: Relative path
            -- 2: Absolute path
            -- 3: Absolute path, with tilde as the home directory
            -- 4: Filename and parent dir, with tilde as the home directory
          },
        },
      },
    }
  end,
}
