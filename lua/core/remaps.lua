-- https://github.com/ThePrimeagen/init.lua/blob/249f3b14cc517202c80c6babd0f9ec548351ec71/lua/theprimeagen/remap.lua
-- https://github.com/exosyphon/nvim/blob/f9580dbb4dbe9db15e66220906c28bcacfaa8942/lua/exosyphon/remaps.lua

-- Set clear when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Half page down (centered)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Half page up (centered)' })

vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines and keep cursor position' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left [W]indow' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right [W]indow' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower [W]indow' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper [W]indow' })

-- Open Terminals
-- vim.keymap.set({ 'n' }, '<leader>tv', ':vsp  term://zsh<cr>', { desc = 'open [v]ertical [t]erminal' })
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
vim.keymap.set('n', '<leader>Q', '<cmd>bufdo if !&modified | bdelete | endif<CR>', { desc = 'Delete Unmodified Buffers' })
vim.keymap.set('n', '<leader>w', ':write<CR>', { desc = '[W]rite Buffer' }) -- write buffer

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', { desc = '[S]plit Window [V]ertically' }) -- split window vertically
vim.keymap.set('n', '<leader>x', ':close<CR>', { desc = '[C]lose Current [S]plit [W]indow' }) -- close current split window

-- Exit insert mode without hitting Esc
-- vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Esc' })

-- Copy file paths
vim.keymap.set('n', '<leader>cf', '<cmd>let @+ = expand("%:t")<CR>', { desc = '[C]opy File Name' })
vim.keymap.set('n', '<leader>cp', '<cmd>let @+ = expand("%:p")<CR>', { desc = '[C]opy File Path' })

-- ThePrimeagen
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")

-- greatest remap ever
-- | Part             | Meaning
-- | ---------------- | -----------------
-- | `'x'`            | Visual mode
-- | `'<leader>p'`    | Your keybinding
-- | `'"_dP'`         | The action (Delete into black hole register(does NOT save it anywhere) → paste
-- | `{ desc = ... }` | Description (for which-key, docs, etc.)
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without yanking' })
-- "_d
-- Deletes text BUT:
-- does NOT save it anywhere
-- your previous yank stays intact
vim.keymap.set({ 'n', 'v' }, '<leader>x', '"_d', { desc = 'Delete without yanking' })

vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww ~/.local/scripts/tmux-sessionizer.sh<CR>')

-- vim-visual-multi
vim.keymap.set('n', '<M-D-Down>', '<Plug>(VM-Select-Cursor-Down)') -- M(Option key) + D(Command key)
vim.keymap.set('n', '<M-D-Up>', '<Plug>(VM-Select-Cursor-Up)')

-- Make current file executable
-- vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })

-- neo-tree
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = 'Toggle Neo-tree' })
vim.keymap.set('n', '<leader>fr', '<cmd>Neotree reveal<cr>', { desc = 'Reveal file in Neo-tree' })
vim.keymap.set('n', '<leader>fg', '<cmd>Neotree git_status<cr>', { desc = 'Neo-tree Git status' })
vim.keymap.set('n', '<leader>fb', '<cmd>Neotree buffers<cr>', { desc = 'Neo-tree Buffers' })

-- mini.bufremove
-- 🔥 Smart delete (BEST VERSION)
vim.keymap.set('n', '<leader>q', function()
  local bufnr = vim.api.nvim_get_current_buf()

  if vim.bo[bufnr].modified then
    -- :help confirm()
    -- confirm({msg}, {choices}, {default})
    -- Choices string -> '&Yes\n&No'
    -- Default choice -> 2
    -- | Option | Index |
    -- | ------ | ----- |
    -- | Yes    | 1     |
    -- | No     | 2     |
    local choice = vim.fn.confirm('Buffer has unsaved changes. Delete anyway?', '&Yes\n&No', 2)
    -- Cancel if user says no
    if choice ~= 1 then
      return
    end
    -- Force delete (after confirmation)
    require('mini.bufremove').delete(bufnr, true)
  else
    require('mini.bufremove').delete(bufnr, false)
  end
end, { desc = '[B]uffer Delete (smart)' })

-- ⚡ Fast force delete
vim.keymap.set('n', '<leader>Q', function()
  require('mini.bufremove').delete(0, true)
end, { desc = '[B]uffer Force Delete' })

-- 🧹 Close others (like VSCode “Close Others”)
vim.keymap.set('n', '<leader>bo', function()
  local current = vim.api.nvim_get_current_buf()

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= current and vim.bo[bufnr].buflisted then
      require('mini.bufremove').delete(bufnr, false)
    end
  end
end, { desc = '[B]uffer Close Others' })

--🧨 Close all buffers
vim.keymap.set('n', '<leader>ba', function()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buflisted then
      require('mini.bufremove').delete(bufnr, true)
    end
  end
end, { desc = '[B]uffer Close All' })
