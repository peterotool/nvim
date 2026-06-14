-- ============================================================
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like iter_captures!
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Set highlight on search
vim.o.hlsearch = true

-- Set this for ToggleTerm terminals to not be discarded when closed
vim.o.hidden = true

-- Without this, code fences may appear as plain text.
-- This mainly affects classic Vim markdown syntax highlighting.
vim.g.markdown_fenced_languages = {
  'javascript',
  'typescript',
  'bash',
  'lua',
  'go',
  'rust',
  'c',
  'cpp',
  'python',
  'java',
  'php',
}

-- Enable built-in Markdown heading folding.
vim.g.markdown_folding = 1

-- Disable swap files.
-- Prevents creation of `.swp` files alongside edited files.
-- Tradeoff:
-- You lose Vim crash-recovery swap backups.
vim.o.swapfile = false

-- Enable true-color support (24-bit RGB colors) in the terminal.
-- Required by many modern themes and UI plugins.
-- bufferline.nvim depends on this for proper rendering.
vim.opt.termguicolors = true

-- Control how concealed text is displayed.
--
-- conceallevel = 2 hides markup syntax while keeping the content visible.
--
-- Example in Markdown:
--   **bold**
--
-- May render visually as:
--   bold
--
-- Commonly used with Obsidian and Markdown plugins to create
-- a cleaner, less noisy reading experience.
-- vim.opt.conceallevel = 2

-- prevent the built-in vim.lsp.completion autotrigger from selecting the first item
vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }
