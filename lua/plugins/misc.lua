vim.pack.add {
  { src = 'https://github.com/windwp/nvim-autopairs' },
  { src = 'https://github.com/hrsh7th/nvim-cmp' },
  { src = 'https://github.com/windwp/nvim-ts-autotag' },
  { src = 'https://github.com/numToStr/Comment.nvim' },
  { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
  { src = 'https://github.com/tpope/vim-sleuth' },
  { src = 'https://github.com/folke/lazydev.nvim' },
  { src = 'https://github.com/Bilal2453/luvit-meta' },
  { src = 'https://github.com/folke/tokyonight.nvim' },
  { src = 'https://github.com/folke/todo-comments.nvim' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
}

-- nvim-autopairs
require('nvim-autopairs').setup {}

local ok_cmp, cmp = pcall(require, 'cmp')
if ok_cmp then
  local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
end

-- nvim-ts-autotag
require('nvim-ts-autotag').setup {}

-- Comment.nvim
require('Comment').setup()

-- indent-blankline (ibl)
require('ibl').setup {}

-- lazydev
require('lazydev').setup {
  library = {
    {
      path = 'luvit-meta/library',
      words = { 'vim%.uv' },
    },
  },
}

-- Load the colorscheme here.
-- Like many other themes, this one has different styles, and you could load
-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
vim.cmd.colorscheme 'tokyonight-night'

-- Highlight todo, notes, etc in comments
require('todo-comments').setup {
  signs = false,
}
