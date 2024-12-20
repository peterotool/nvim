-- https://github.com/ThePrimeagen/init.lua/blob/249f3b14cc517202c80c6babd0f9ec548351ec71/lua/theprimeagen/remap.lua
-- https://github.com/exosyphon/nvim/blob/f9580dbb4dbe9db15e66220906c28bcacfaa8942/lua/exosyphon/remaps.lua

-- Move between splits
vim.keymap.set('n', '<c-j>', '<c-w><c-j>')
vim.keymap.set('n', '<c-k>', '<c-w><c-k>')
vim.keymap.set('n', '<c-l>', '<c-w><c-l>')
vim.keymap.set('n', '<c-h>', '<c-w><c-h>')

-- Keymap to open ipython
vim.keymap.set({ 'n' }, '<leader>ti', ':split  term://ipython<cr>', { desc = '[C]ode repl [I]python' })
vim.keymap.set({ 'n' }, '<leader>tt', ':split  term://zsh<cr>', { desc = '[Open] [T]erminal' })

-- Exit insert mode without hitting Esc
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Esc' })

-- Jump between markdown headers
vim.keymap.set('n', 'gj', [[/^##\+ .*<CR>]], { buffer = true, silent = true })
vim.keymap.set('n', 'gk', [[?^##\+ .*<CR>]], { buffer = true, silent = true })

-- close buffer
vim.keymap.set('n', '<leader>q', '<cmd>bd<CR>', { desc = 'Close Buffer' })

-- Copy file paths
vim.keymap.set('n', '<leader>cf', '<cmd>let @+ = expand("%")<CR>', { desc = 'Copy File Name' })
vim.keymap.set('n', '<leader>cp', '<cmd>let @+ = expand("%:p")<CR>', { desc = 'Copy File Path' })

-- ThePrimeagen
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")

-- greatest remap ever
-- https://youtu.be/w7i4amO_zaE?list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R&t=1597
vim.keymap.set('x', '<leader>p', [["_dP]])

vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')
