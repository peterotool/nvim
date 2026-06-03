-- https://github.com/nvim-treesitter/nvim-treesitter
return {
  {
    -- Main Treesitter plugin
    -- Provides syntax highlighting, indentation, text objects,
    -- incremental selection, and a syntax tree API.
    'nvim-treesitter/nvim-treesitter',

    -- Treesitter should not be lazy-loaded.
    -- The maintainers explicitly recommend loading it at startup.
    lazy = false,

    -- Whenever the plugin is updated, update installed parsers too.
    build = ':TSUpdate',

    config = function()
      require('nvim-treesitter').setup {

        -- Where Treesitter parsers will be installed.
        -- Default:
        -- ~/.local/share/nvim/site
        install_dir = vim.fn.stdpath 'data' .. '/site',

        -- Languages that should always be installed.
        -- Treesitter downloads a parser for each language.
        ensure_installed = {
          'go',
          'lua',
          'python',
          'rust',
          'regex',
          'bash',
          'sql',
          'c',
          'html',
          'vim',
          'vimdoc',
        },

        -- Automatically install missing parsers when opening files.
        --
        -- Example:
        -- Open a JavaScript file without the parser installed →
        -- Treesitter downloads it automatically.
        auto_install = true,

        -- Syntax highlighting configuration.
        highlight = {
          -- Enable Treesitter-based highlighting.
          enable = true,

          -- Keep Vim's regex highlighter enabled for specific languages.
          --
          -- Some languages still rely on Vim regex highlighting for
          -- certain features. Ruby indentation is a common example.
          additional_vim_regex_highlighting = {
            'ruby',
          },
        },

        -- Treesitter-based indentation.
        indent = {
          enable = true,

          -- Disable Treesitter indentation for languages where
          -- it is known to be unreliable.
          disable = {
            'ruby',
          },
        },
      }
    end,
  },
}
