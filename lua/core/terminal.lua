local set = vim.opt_local

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', {}),
  callback = function()
    set.number = false
    set.relativenumber = false
    set.scrolloff = 0
  end,
})

vim.api.nvim_command 'autocmd TermOpen * startinsert' -- starts in insert mode
-- vim.api.nvim_command 'autocmd TermOpen * setlocal nonumber norelativenumber' -- no numbers
-- vim.api.nvim_command 'autocmd TermEnter * setlocal signcolumn=no' -- no sign column

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set('n', ',st', function()
  vim.cmd.new()
  vim.cmd.wincmd 'J'
  vim.api.nvim_win_set_height(0, 12)
  vim.wo.winfixheight = true
  vim.cmd.term()
end)

