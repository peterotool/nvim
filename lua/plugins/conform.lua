vim.pack.add { { src = 'https://github.com/stevearc/conform.nvim' } }

local conform = require 'conform'

conform.setup {
  -- Don't show notifications when formatting fails
  notify_on_error = false,

  -- Auto-format on save
  format_on_save = function(bufnr)
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
    -- Language-specific
    python = { 'ruff' },
    lua = { 'stylua' },
    rust = { 'rustfmt' },
    toml = { 'taplo' },
    sh = { 'shfmt' },
    -- Prettier
    json = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
  },
}

-- Manual format
vim.keymap.set('n', '<leader>f', function()
  conform.format {
    async = true,
    lsp_format = 'fallback',
  }
end, {
  desc = '[F]ormat buffer',
})

-- Auto-format before save
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(args)
    conform.format {
      bufnr = args.buf,
      timeout_ms = 500,
      lsp_format = 'fallback',
    }
  end,
})

-- Optional utility command
vim.api.nvim_create_user_command('ConformInfo', function()
  vim.cmd 'ConformInfo'
end, {})
