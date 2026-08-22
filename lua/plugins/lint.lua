vim.pack.add { { src = 'https://github.com/mfussenegger/nvim-lint' } }

local lint = require 'lint'

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
  bash = { 'shellcheck' },
  yaml = { 'yamllint' },
  terraform = { 'tflint' },
  json = { 'jsonlint' },
}

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    if vim.bo.modifiable then
      -- cwd is set to the file's directory so markdownlint-cli2 discovers .markdownlint.jsonc
      -- by walking up from there; other linters (ruff, shellcheck, etc.) are unaffected by cwd
      lint.try_lint(nil, { cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h') })
    end
  end,
})

vim.keymap.set('n', '<leader>l', function()
  -- see autocmd above for cwd rationale
  lint.try_lint(nil, { cwd = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':h') })
end, { desc = '[Lint] buffer' })
