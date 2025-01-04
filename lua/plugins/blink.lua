-- https://github.com/Saghen/blink.cmp
return {
  {
    'saghen/blink.cmp', -- Autocompletion
    dependencies = 'rafamadriz/friendly-snippets',

    version = 'v0.*',

    opts = {
      keymap = { preset = 'default' },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },

      signature = { enabled = true },
    },
  },
}
