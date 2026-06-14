-- install with yarn or npm
-- cd ~/.local/share/nvim/site/pack/core/opt/markdown-preview.nvim/app
-- yarn install
--
vim.pack.add { { src = 'https://github.com/iamcco/markdown-preview.nvim' } }

vim.g.mkdp_filetypes = { 'markdown' }

-- Optional: create commands so the plugin only loads when used
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>', {
      buffer = true,
      desc = 'Markdown Preview',
    })
  end,
})
