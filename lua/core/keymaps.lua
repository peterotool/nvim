-- ============================================================
-- basic keymaps
-- ============================================================
-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
--  See `:help vim.diagnostic.Opts`
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = false, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Open Terminals
-- vim.keymap.set({ 'n' }, '<leader>tv', ':vsp  term://zsh<cr>', { desc = 'open [v]ertical [t]erminal' })
-- vim.keymap.set({ 'n' }, '<leader>th', ':sp  term://zsh<cr>', { desc = 'Open [H]orizontal [T]erminal' })

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

-- Center screen after various operations
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Keep cursor centered' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Keep cursor centered' })

-- Copy file paths
vim.keymap.set('n', '<leader>cf', '<cmd>let @+ = expand("%:t")<CR>', { desc = '[C]opy File Name' })
vim.keymap.set('n', '<leader>cp', '<cmd>let @+ = expand("%:p")<CR>', { desc = '[C]opy File Path' })

-- ThePrimeagen
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")

-- greatest remap ever
-- Paste over selected text WITHOUT replacing your current yank/clipboard.
--
-- Default Vim behavior when pressing `p` in visual mode:
--   1. Delete selected text
--   2. Save deleted text into the unnamed register
--   3. Paste previous yank
--
-- Problem:
--   Your previous yank gets overwritten by the deleted text.
--
-- This remap fixes that by using the black hole register (`"_`):
--   "_dP
--
-- Breakdown:
--   "_d -> delete selection WITHOUT yanking it
--   P   -> paste previously yanked text
--
-- Result:
--   You can repeatedly paste/replace text while keeping the same yank.
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'Paste without yanking' })
-- "_d
-- Deletes text BUT:
-- does NOT save it anywhere
-- your previous yank stays intact
-- vim.keymap.set({ 'n', 'v' }, '<leader>x', '"_d', { desc = 'Delete without yanking' })

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

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { desc = '[N]ext Buffer' }) -- next buffer
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { desc = '[P]reviuos Buffer' }) -- previous buffer
vim.keymap.set('n', '<leader>q', ':bd<CR>', { desc = '[B]uffer Delete ' })
vim.keymap.set('n', '<leader>Q', '<cmd>bufdo if !&modified | bdelete | endif<CR>', { desc = 'Delete Unmodified Buffers' })
vim.keymap.set('n', '<leader>w', ':write<CR>', { desc = '[W]rite Buffer' }) -- write buffer

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', { desc = '[S]plit Window [V]ertically' }) -- split window vertically
vim.keymap.set('n', '<leader>x', ':close<CR>', { desc = '[C]lose Current [S]plit [W]indow' }) -- close current split window
