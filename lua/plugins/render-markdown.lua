vim.pack.add {
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
}

require('render-markdown').setup {
  -- preset = 'obsidian',

  heading = {
    enabled = false,
  },
  -- paragraph = { enabled = false },
  -- code = { enabled = false },
  -- bullet = { enabled = false },
  -- checkbox = { enabled = false },
  -- quote = { enabled = false },
  -- pipe_table = { enabled = true },
  code = {
    enabled = false,
  },

  -- checklist bug:
  -- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/545
  --
  -- When rendering markdown task lists, the first 3 letters may be
  -- missing and hierarchy/indentation can render incorrectly.
  -- Workaround: increase right_pad.

  -- checkbox = {
  --   right_pad = 5,
  -- },

  bullet = {
    right_pad = 1,
  },
}
