vim.pack.add { { src = 'https://github.com/mbbill/undotree', name = 'undotree' } }

vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<cr>', { desc = 'Undotree' })
