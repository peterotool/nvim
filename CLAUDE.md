# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Plugin Management

This config uses **`vim.pack`**, Neovim's built-in plugin manager (available since Neovim 0.11+). There is no lazy.nvim or other external plugin manager.

- Install/update plugins: `:lua vim.pack.update()`
- Check pending updates (offline): `:lua vim.pack.update(nil, { offline = true })`
- Add a plugin: `vim.pack.add { 'https://github.com/author/repo.nvim' }`
- Post-install build hooks live in `init.lua` inside the `PackChanged` autocmd

LSP servers and formatters/linters are installed via **Mason** (`:Mason`). The full list of managed servers and tools is in `lua/plugins/nvim-lspconfig.lua`.

## Architecture

```
init.lua                  -- Entry point: build hooks, ui2, then loads core.* and plugins
lua/
  core/
    options.lua           -- vim.o/vim.opt settings, leaders, globals
    keymaps.lua           -- Global keymaps, diagnostic config, and window/buffer management
  plugins/
    init.lua              -- Auto-requires every other *.lua file in this directory
    nvim-lspconfig.lua    -- LSP setup, Mason, native completion, inlay hints
    conform.lua           -- Formatting (format-on-save + <leader>f)
    lint.lua              -- nvim-lint linters, triggered on BufEnter/BufWritePost/InsertLeave
    dap.lua               -- Debug Adapter Protocol (nvim-dap + dapui + Python)
    telescope.lua         -- Fuzzy finder + LSP pickers on LspAttach
    mini.lua              -- mini.nvim: icons, ai textobjects, surround, statusline
    misc.lua              -- Colorscheme (tokyonight-night), autopairs, comments, lazydev
    treesitter.lua        -- Syntax highlighting and parsing
    ...                   -- One file per plugin for everything else
```

**Plugin loading:** `lua/plugins/init.lua` iterates the directory and `require`s every `*.lua` file except itself. Each plugin file calls `vim.pack.add` at the top, then does its own setup. Adding a new plugin = create a new file in `lua/plugins/`.

## Formatting and Linting

**Formatter** (`conform.nvim`): auto-runs on `BufWritePre`. Per-filetype: `ruff` (Python), `stylua` (Lua), `rustfmt` (Rust), `taplo` (TOML), `shfmt` (shell), `prettier` (JSON/YAML/Markdown). Stylua config: `.stylua.toml` (160 col, 2-space indent, single quotes).

**Linter** (`nvim-lint`): triggers on buffer enter, write, and insert-leave. Per-filetype: `markdownlint-cli2` (Markdown), `ruff --select ALL` (Python), `shellcheck` (shell), `yamllint` (YAML), `tflint` (Terraform), `jsonlint` (JSON).

To format Lua files manually: `stylua lua/`

## Key Mappings (Leader = `<Space>`)

| Key | Action |
|-----|--------|
| `<leader>f` | Format buffer |
| `<leader>l` | Lint buffer |
| `<leader>e` | Toggle Neo-tree |
| `<leader>sg` / `<leader>sf` | Live grep / find files (Telescope) |
| `<leader>sh` | Search help tags |
| `<leader>sn` | Search Neovim config files |
| `<leader><leader>` | Find open buffers |
| `<leader>b` / `<leader>B` | Toggle / conditional breakpoint |
| `<F5>` | DAP continue |
| `<F1/2/3>` | Step into/over/out |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `<leader>q` / `<leader>Q` | Delete buffer / delete all unmodified buffers |
| `<leader>w` | Write buffer |
| `<leader>v` / `<leader>x` | Split vertical / close split |
| `grr/grd/gri/grt` | LSP references/definition/implementation/type (Telescope) |
| `grn` / `gra` | LSP rename / code action |

## LSP

Enabled servers: `bashls`, `dockerls`, `gopls`, `ruff`, `rust_analyzer`, `marksman`, `terraformls`, `pyright`, `lua_ls`. All are auto-installed via Mason. `lua_ls` formatting is disabled (stylua handles it). Native completion (`vim.lsp.completion`) is used — no nvim-cmp for LSP completion.

## DAP (Debugging)

Python debugging uses `dap-python` with `uv` as the Python provider. Breakpoints are persistent across sessions via `persistent-breakpoints.nvim`. The DAP UI opens/closes automatically on session start/end.

## Prerequisites

- Neovim with `vim.pack` support (0.11+)
- `ripgrep` (required for Telescope live grep)
- `make` (for telescope-fzf-native and LuaSnip build steps)
- `uv` (for Python DAP)
- Nerd Font (for icons — `vim.g.have_nerd_font = true`)
