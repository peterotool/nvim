-- https://github.com/mfussenegger/nvim-lint
return {
  -- Linting plugin
  'mfussenegger/nvim-lint',

  -- Load when opening or creating files
  event = {
    'BufReadPre',
    'BufNewFile',
  },

  config = function()
    local lint = require 'lint'

    -- Python: run Ruff with all rules enabled
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

    -- Linters by filetype
    lint.linters_by_ft = {
      python = { 'ruff' },
      sh = { 'shellcheck' },
      yaml = { 'yamllint' },
      terraform = { 'tflint' },
      json = { 'jsonlint' },

      -- Markdown is formatted with Prettier, not linted
      -- markdown = {}
    }

    -- Automatically lint when:
    -- - Entering a buffer
    -- - Saving a file
    -- - Leaving insert mode
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

    vim.api.nvim_create_autocmd({
      'BufEnter',
      'BufWritePost',
      'InsertLeave',
    }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Manual lint: <leader>l
    vim.keymap.set('n', '<leader>l', function()
      lint.try_lint()
    end, {
      desc = '[Lint] buffer',
    })
  end,
}
