vim.pack.add { { src = 'https://github.com/stevearc/conform.nvim' } }

local conform = require 'conform'

conform.setup {
  -- Don't show notifications when formatting fails
  notify_on_error = false,

  -- Auto-format on save
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return false
    end
    return { timeout_ms = 500, lsp_format = 'fallback' }
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
    jsonc = { 'prettier' },
    yaml = { 'prettier' },
    markdown = { 'prettier' },
  },

  -- Per-formatter options
  formatters = {
    -- preserve-wrap prevents prettier from reflowing/joining markdown prose lines;
    -- list indentation is still normalized (consistent with MD007 indent:2)
    prettier = {
      prepend_args = { '--prose-wrap', 'preserve' },
    },
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
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[args.buf].filetype] then
      return
    end
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
