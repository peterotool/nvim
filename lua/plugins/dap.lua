return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'mfussenegger/nvim-dap-python',

    'theHamsta/nvim-dap-virtual-text',
    -- Persist breakpoints between sessions
    'Weissle/persistent-breakpoints.nvim',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
    {
      '<leader>b',
      function()
        require('persistent-breakpoints.api').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('persistent-breakpoints.api').set_conditional_breakpoint()
      end,
      desc = 'Debug: Conditional Breakpoint',
    },
    {
      '<leader>bc',
      function()
        require('persistent-breakpoints.api').clear_all_breakpoints()
      end,
      desc = 'Debug: Clear All Breakpoints',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local dap_python = require 'dap-python'

    -- persistent-breakpoints setup
    require('persistent-breakpoints').setup {
      load_breakpoints_event = { 'BufReadPost' }, -- load breakpoints when files are read
    }
    require('nvim-dap-virtual-text').setup {
      commented = true, -- Show virtual text alongside comment
    }
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'python',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        enabled = true,
        element = 'repl',
        icons = {
          pause = ' pause', -- codicon: debug-pause
          play = '', -- codicon: debug-start
          step_into = '', -- codicon: debug-step-into
          step_over = '', -- codicon: debug-step-over
          step_out = '', -- codicon: debug-step-out
          step_back = '', -- codicon: debug-step-back
          run_last = '', -- codicon: debug-rerun
          terminate = '', -- codicon: debug-stop
          disconnect = '', -- codicon: debug-disconnect
        },
      },
    }
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install python specific config
    dap_python.setup 'uv'
    table.insert(require('dap').configurations.python, {
      type = 'python',
      request = 'launch',
      name = 'My custom launch configuration',
      program = '${file}',
      cwd = function()
        return vim.fn.getcwd()
      end,
      -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
      -- justMyCode = false, -- 👈 allow stepping into libraries
    })

    -- Define a custom sign for breakpoints
    -- Define the highlight color
    vim.fn.sign_define('DapBreakpoint', {
      text = '●', -- icon for breakpoints
      texthl = 'DapBreakpoint', -- highlight group
      linehl = '', -- highlight entire line (optional)
      numhl = '', -- highlight number column (optional)
    })
    vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#FF0000' }) -- pure red
  end,
}
