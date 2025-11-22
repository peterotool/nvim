-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },

      -- Document existing key chains
    -- Document existing key chains
    spec = {
      { '<leader>g', group = '[G]itSigns' ,mode = { 'n', 'v' } },
      { '<leader>c', group = '[C]opy File', mode = { 'n', 'v' } },
      { '<leader>s', group = '[S]earch Telescopce' },
      { '<leader>t', group = '[T]oggle Terminal' },
    },
  },
}
