-- https://github.com/ThePrimeagen/init.lua/blob/249f3b14cc517202c80c6babd0f9ec548351ec71/lua/theprimeagen/remap.lua
-- https://github.com/exosyphon/nvim/blob/f9580dbb4dbe9db15e66220906c28bcacfaa8942/lua/exosyphon/remaps.lua

-- Set clear when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left [W]indow' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right [W]indow' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower [W]indow' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper [W]indow' })

-- Open Terminals
-- vim.keymap.set({ 'n' }, '<leader>tv', ':vsp  term://zsh<cr>', { desc = 'Open [V]ertical [T]erminal' })
-- vim.keymap.set({ 'n' }, '<leader>th', ':sp  term://zsh<cr>', { desc = 'Open [H]orizontal [T]erminal' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Center screen after various operations
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Keep cursor centered' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Keep cursor centered' })

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = '[N]ext Buffer' }) -- next buffer
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = '[P]reviuos Buffer' }) -- previous buffer
vim.keymap.set('n', '<leader>q', '<cmd>bdelete!<CR>', { desc = '[D]elete Buffer' }) -- delete buffer

vim.keymap.set('n', '<leader>w', ':write<CR>', { desc = '[W]rite Buffer' }) -- write buffer

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', { desc = '[S]plit Window [V]ertically' }) -- split window vertically
vim.keymap.set('n', '<leader>x', ':close<CR>', { desc = '[C]lose Current [S]plit [W]indow' }) -- close current split window

-- Exit insert mode without hitting Esc
-- vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Esc' })

-- Jump between markdown headers
vim.keymap.set('n', 'gj', [[/^##\+ .*<CR>]], { desc = 'Jump Foward Markdown Header' })
vim.keymap.set('n', 'gk', [[?^##\+ .*<CR>]], { desc = 'Jump Backward Markdown Header' })

-- Copy file paths
vim.keymap.set('n', '<leader>cf', '<cmd>let @+ = expand("%:t")<CR>', { desc = '[C]opy File Name' })
vim.keymap.set('n', '<leader>cp', '<cmd>let @+ = expand("%:p")<CR>', { desc = '[C]opy File Path' })

-- ThePrimeagen
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")

-- greatest remap ever
-- https://youtu.be/w7i4amO_zaE?list=PLm323Lc7iSW_wuxqmKx_xxNtJC_hJbQ7R&t=1597
vim.keymap.set('x', '<leader>p', [["_dP]])

vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

-- vim-visual-multi
vim.keymap.set('n', '<M-D-Down>', '<Plug>(VM-Select-Cursor-Down)') -- M(Option key) + D(Command key)
vim.keymap.set('n', '<M-D-Up>', '<Plug>(VM-Select-Cursor-Up)')

-- Make current file executable
-- vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })
