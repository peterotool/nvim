vim.pack.add { { src = 'https://github.com/nvim-lualine/lualine.nvim' } }

require('lualine').setup {
  options = {
    icons_enabled = true,
    component_separators = '|',
    section_separators = '',
  },

  sections = {
    lualine_c = {
      {
        'filename',
        path = 3,
      },
    },
  },
}
