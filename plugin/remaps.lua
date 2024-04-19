-- Move between splits
vim.keymap.set("n", "<c-j>", "<c-w><c-j>")
vim.keymap.set("n", "<c-k>", "<c-w><c-k>")
vim.keymap.set("n", "<c-l>", "<c-w><c-l>")
vim.keymap.set("n", "<c-h>", "<c-w><c-h>")

-- Keymap to open ipython
vim.keymap.set({ 'n' }, '<leader>ti', ':split  term://ipython<cr>', { desc = '[C]ode repl [I]python' })
vim.keymap.set({ 'n' }, '<leader>tt', ':split  term://zsh<cr>', { desc = '[Open] [T]erminal' })

-- Exit insert mode without hitting Esc
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Esc' })

-- Jump between markdown headers
vim.keymap.set('n', 'gj', [[/^##\+ .*<CR>]], { buffer = true, silent = true })
vim.keymap.set('n', 'gk', [[?^##\+ .*<CR>]], { buffer = true, silent = true })

-- Move between buffers
-- vim.keymap.set('n', '<C-l>', ':bnext<CR>', { silent = true })
-- vim.keymap.set('n', '<C-h>', ':bprevious<CR>', { silent = true })

-- close buffer
vim.keymap.set('n', '<leader>q', '<cmd>bd<CR>', { desc = 'Close Buffer' })

-- Copy file paths
vim.keymap.set('n', '<leader>cf', '<cmd>let @+ = expand("%")<CR>', { desc = 'Copy File Name' })
vim.keymap.set('n', '<leader>cp', '<cmd>let @+ = expand("%:p")<CR>', { desc = 'Copy File Path' })

