-- https://github.com/folke/which-key.nvim
return {
  -- Shows available keymaps as you type
  'folke/which-key.nvim',

  -- Load when Neovim starts
  event = 'VimEnter',

  opts = {
    -- Show popup immediately
    delay = 0,

    -- Use Nerd Font icons when available
    icons = {
      mappings = vim.g.have_nerd_font,
    },

    -- Group related keymaps in the popup
    spec = {
      { '<leader>g', group = '[G]itSigns', mode = { 'n', 'v' } },
      { '<leader>c', group = '[C]opy File', mode = { 'n', 'v' } },
      { '<leader>s', group = '[S]earch Telescope' },
      { '<leader>t', group = '[T]oggle Terminal' },
    },
  },
}
