-- https://github.com/stevearc/conform.nvim
return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      local lsp_format_opt
      if disable_filetypes[vim.bo[bufnr].filetype] then
        lsp_format_opt = 'never'
      else
        lsp_format_opt = 'fallback'
      end
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- You can customize some of the format options for the filetype (:help conform.format)
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
      --
      -- lua =require("conform").list_all_formatters()
      python = {
        -- To fix auto-fixable lint errors.
        'ruff_fix',
        -- To run the Ruff formatter.
        'ruff_format',
        -- To organize the imports.
        'ruff_organize_imports',
      },
      json = { 'prettier' },
      markdown = { 'markdownlint-cli2', 'markdown-toc' },
      rust = { 'rustfmt' },
      yaml = { 'prettier' },
      toml = { 'taplo' },
      sh = { 'shfmt' },
    },
    -- https://kitsugo.com/guide/nvim-default-formatter/
    formatters = {
      ['markdownlint-cli2'] = {
        prepend_args = function()
          return {
            '--config',
            vim.fn.expand '~/.dotfiles/stow/nvim/.config/nvim/.markdownlint.jsonc',
          }
        end,
      },
    },
  },
}
