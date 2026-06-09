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
    -- lua print(vim.inspect(require('lint.linters.markdownlint-cli2')))
    -- lua =require('lint.linters.markdownlint-cli2')
    local markdownlint = lint.linters['markdownlint-cli2']

    markdownlint.args = vim.list_extend({
      '--config',
      vim.fn.expand '~/.dotfiles/stow/nvim/.config/nvim/.markdownlint.jsonc',
    }, markdownlint.args)

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
      markdown = { 'markdownlint-cli2' },
      python = { 'ruff' },
      sh = { 'shellcheck' },
      yaml = { 'yamllint' },
      terraform = { 'tflint' },
      json = { 'jsonlint' },
    }

    -- Create autocommand which carries out the actual linting
    -- on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- Only run the linter in modifiable buffers.
        if vim.bo.modifiable then
          lint.try_lint()
        end
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
