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
      yaml = { 'prettier' },
      markdown = { 'markdownlint-cli2', 'markdown-toc' },
      rust = { 'rustfmt' },
      toml = { 'taplo' },
      sh = { 'shfmt' },
    },
    -- https://kitsugo.com/guide/nvim-default-formatter/
    formatters = {
      -- We use ['markdownlint-cli2'] instead of markdownlint-cli2
      -- because Lua keys with dashes (-) are NOT valid identifiers.
      -- Without brackets, Lua would interpret it as subtraction:
      -- markdownlint - cli2 (which is invalid here).
      ['markdownlint-cli2'] = {
        -- prepend_args lets you add CLI arguments before the formatter runs
        prepend_args = function()
          return {
            -- --config tells markdownlint-cli2 to use a custom config file
            '--config',

            -- vim.fn.expand expands the ~ to your home directory
            -- so this becomes an absolute path like /home/user/...
            vim.fn.expand '~/.dotfiles/stow/nvim/.config/nvim/.markdownlint.jsonc',
          }
        end,
      },
    },
  },
}
