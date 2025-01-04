-- https://github.com/mfussenegger/nvim-lint
-- https://www.josean.com/posts/neovim-linting-and-formatting
return { -- Linting
  'mfussenegger/nvim-lint',
  event = {
    'BufReadPre',
    'BufNewFile',
  },
  config = function()
    local lint = require 'lint'
    local HOME = os.getenv 'HOME'

    -- lua print(vim.inspect(require('lint.linters.markdownlint-cli2')))
    -- lua =require('lint.linters.markdownlint-cli2')
    lint.linters['markdownlint-cli2'].args = { '--config', HOME .. '/.dotfiles/stow/nvim/.config/nvim/.markdownlint.jsonc', '--' }
    -- lua =require('lint.linters.ruff')
    lint.linters['ruff'].args = {
      'check',
      '--stdin-filename',
      function()
        return vim.api.nvim_buf_get_name(0)
      end,
      '--select',
      'ALL',
      '--quiet',
      '-',
    }
    lint.linters_by_ft = {
      markdown = { 'markdownlint-cli2' },
      python = { 'ruff' },
      sh = { 'shellcheck' },
      -- lua print(vim.inspect(require('lint').linters_by_ft[vim.bo.filetype]))
      yaml = { 'yamllint' },
      terraform = { 'tflint' },
      json = { 'jsonlint' },
    }

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        require('lint').try_lint()
      end,
    })

    vim.keymap.set('n', '<leader>l', function()
      lint.try_lint()
    end, { desc = '[Lint] buffer' })
  end,
}
