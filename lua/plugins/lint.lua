vim.pack.add { { src = 'https://github.com/mfussenegger/nvim-lint' } }

local lint = require 'lint'

local markdownlint_config = vim.fn.expand '~/.dotfiles/stow/nvim/.config/nvim/.markdownlint.jsonc'
if vim.fn.filereadable(markdownlint_config) == 1 then
  local markdownlint = lint.linters['markdownlint-cli2']
  markdownlint.args = vim.list_extend({
    '--config',
    markdownlint_config,
  }, markdownlint.args)
end

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
  yaml = { 'yamllint' },
  terraform = { 'tflint' },
  json = { 'jsonlint' },
}

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    if vim.bo.modifiable then
      lint.try_lint()
    end
  end,
})

vim.keymap.set('n', '<leader>l', function()
  lint.try_lint()
end, { desc = '[Lint] buffer' })
