return {
  -- Debugging
  'mfussenegger/nvim-dap',

  dependencies = {
    -- python
    'mfussenegger/nvim-dap-python',
    'nvim-neotest/nvim-nio',
    'rcarriga/nvim-dap-ui'
  },
  lazy = false,
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    require('dapui').setup()
    require('dap-python').setup('python')

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end


    dap.adapters.lldb = {
      type = "executable",
      command = "/usr/bin/lldb",       -- adjust as needed
      name = "lldb",
    }
    dap.configurations.rust = {
      {
        name = "hello-world",
        type = "lldb",
        request = "launch",
        program = function()
          return vim.fn.getcwd() .. "/target/debug/hello-world"
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
    dap.configurations.python = {
      {
        -- The first three options are required by nvim-dap
        type = 'python',      -- indicates the type of configuration
        request = 'launch',   -- whether to launch or attach to the process
        name = "Launch File", -- name for the configuration
        -- Options specific to Python configurations
        program = "${file}",  -- This configuration will debug the current file
        pythonPath = function()
          -- Use virtualenv or default python in your PATH
          return 'python' -- Update this if necessary
        end,
      },
      {
        -- The first three options are required by nvim-dap
        type = 'python',                    -- indicates the type of configuration
        request = 'launch',                 -- whether to launch or attach to the process
        name = "Launch File - Halter Data", -- name for the configuration
        -- Options specific to Python configurations
        program = "${file}",                -- This configuration will debug the current file
        pythonPath = 'python',              -- Update this if necessary
        env = function()
          local env_vars = {}
          -- Capture the environment variables set by aws-vault exec
          local handle = io.popen("aws-vault exec halter-data -- env")
          if handle then
            for line in handle:lines() do
              -- Parse the environment variable output (e.g., "KEY=VALUE")
              local key, value = line:match("([^=]+)=([^=]+)")
              if key and value then
                env_vars[key] = value
              end
            end
            handle:close()
          else
            print("Failed to execute aws-vault command")
          end
          return env_vars
        end,
      },
      {
        type = 'debugpy',
        request = 'attach',
        name = "Attach to Debugpy Process Port:5678",
        host = "localhost",   -- Host where debugpy is running
        port = 5678,          -- Port where debugpy is listening
      },
    }
  end,
}
