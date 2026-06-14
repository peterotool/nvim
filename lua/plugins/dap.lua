vim.pack.add {
  { src = 'https://github.com/mfussenegger/nvim-dap' },
  { src = 'https://github.com/rcarriga/nvim-dap-ui' },
  { src = 'https://github.com/nvim-neotest/nvim-nio' },
  { src = 'https://github.com/williamboman/mason.nvim' },
  { src = 'https://github.com/jay-babu/mason-nvim-dap.nvim' },
  { src = 'https://github.com/mfussenegger/nvim-dap-python' },
  { src = 'https://github.com/theHamsta/nvim-dap-virtual-text' },
  { src = 'https://github.com/Weissle/persistent-breakpoints.nvim' },
}

local dap = require 'dap'
local dapui = require 'dapui'
local dap_python = require 'dap-python'

require('persistent-breakpoints').setup {
  load_breakpoints_event = { 'BufReadPost' },
}

require('nvim-dap-virtual-text').setup {
  commented = true,
}

require('mason-nvim-dap').setup {
  automatic_installation = true,
  handlers = {},
  ensure_installed = {
    'python',
  },
}

dapui.setup {
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  controls = {
    enabled = true,
    element = 'repl',
    icons = {
      pause = ' pause',
      play = '',
      step_into = '',
      step_over = '',
      step_out = '',
      step_back = '',
      run_last = '',
      terminate = '',
      disconnect = '',
    },
  },
}

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

dap_python.setup 'uv'
table.insert(dap.configurations.python, {
  type = 'python',
  request = 'launch',
  name = 'My custom launch configuration',
  program = '${file}',
  cwd = function()
    return vim.fn.getcwd()
  end,
})

vim.fn.sign_define('DapBreakpoint', {
  text = '●',
  texthl = 'DapBreakpoint',
  linehl = '',
  numhl = '',
})
vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#FF0000' })

vim.keymap.set('n', '<F5>', function()
  require('dap').continue()
end, { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', function()
  require('dap').step_into()
end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', function()
  require('dap').step_over()
end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', function()
  require('dap').step_out()
end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<F7>', function()
  require('dapui').toggle()
end, { desc = 'Debug: See last session result.' })
vim.keymap.set('n', '<leader>b', function()
  require('persistent-breakpoints.api').toggle_breakpoint()
end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>B', function()
  require('persistent-breakpoints.api').set_conditional_breakpoint()
end, { desc = 'Debug: Conditional Breakpoint' })
vim.keymap.set('n', '<leader>bc', function()
  require('persistent-breakpoints.api').clear_all_breakpoints()
end, { desc = 'Debug: Clear All Breakpoints' })
