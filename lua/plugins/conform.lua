-- https://github.com/stevearc/conform.nvim
return {
  -- Formatting plugin
  'stevearc/conform.nvim',

  -- Load before saving files
  event = { 'BufWritePre' },

  -- Utility command
  cmd = { 'ConformInfo' },

  -- Manual format: <leader>f
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format {
          async = true,
          lsp_format = 'fallback',
        }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },

  opts = {
    -- Don't show notifications when formatting fails
    notify_on_error = false,

    -- Auto-format on save
    format_on_save = function(bufnr)
      -- Disable LSP formatting fallback for languages
      -- where formatting is often project-specific.
      local disable_filetypes = {
        c = true,
        cpp = true,
      }

      return {
        timeout_ms = 500,
        lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback',
      }
    end,

    -- Formatters by filetype
    formatters_by_ft = {
      -- Lua
      lua = { 'stylua' },

      -- Python: fix issues, format code, organize imports
      python = {
        'ruff_fix',
        'ruff_format',
        'ruff_organize_imports',
      },

      -- Prettier-based formats
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },

      -- Language-specific formatters
      rust = { 'rustfmt' },
      toml = { 'taplo' },
      sh = { 'shfmt' },
    },
  },
}
