return {
    -- Debugging
    "mfussenegger/nvim-dap",
    -- wants = { "nvim-dap-virtual-text", "nvim-dap-ui", "nvim-dap-python",
    --     "which-key.nvim" },
    dependencies = {
        "williamboman/mason.nvim",
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "mfussenegger/nvim-dap-python",
        "nvim-telescope/telescope-dap.nvim",
        "jbyuki/one-small-step-for-vimkind",
    },
    lazy=true,
    keys = {

        { mode={ 'n', 'v' }, '<F5>',  function() require('dap').continue() end,  desc = "DAP continue" },
        { mode={ 'n', 'v' }, '<F10>', function() require('dap').step_over() end, desc = "DAP step over" },
        { mode={ 'n', 'v' }, '<F11>', function() require('dap').step_into() end, desc = "DAP step into" },
        { mode={ 'n', 'v' }, '<F12>', function() require('dap').step_out() end,  desc = "DAP step out" },
        {
            mode='n',
            '<leader>b',
            function() require('dap').toggle_breakpoint() end,
            desc = "DAP toggle breakpoint"
        },
        {
            mode='n',
            '<leader>B',
            function() require('dap').set_breakpoint() end,
            desc = "DAP set breakpoint"
        },
        {
            mode='n',
            '<leader>lp',
            function()
                require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
            end,
            desc = "DAP set breakpoint with message"
        },
        {
            mode='n',
            '<leader>dr',
            function() require('dap').repl.open() end,
            desc = "DAP repl open"
        },
        {
            mode='n',
            '<leader>dl',
            function() require('dap').run_last() end,
            desc = "DAP run last"
        },
        {
            mode={ 'n', 'v' },
            '<leader>dh',
            function()
                require('dap.ui.widgets').hover()
            end,
            desc = "DAP hover"
        },
        {
            mode={ 'n', 'v' },
            '<leader>dp',
            function()
                require('dap.ui.widgets').preview()
            end,
            desc = "DAP preview"
        },
        {
            mode='n',
            '<leader>df',
            function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.frames)
            end,
            desc = "DAP frames"
        },
        {
            mode='n',
            '<leader>ds',
            function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.scopes)
            end,
            desc = "DAP scopes"
        },
        {
            mode='n',
            '<leader>do',
            function()
                require('dapui').open()
            end,
            desc = "DAP open dapui"
        },
    },
    config = function()
        local dap = require('dap')

        local dap_py = require("dap-python")
        dap_py.setup("uv")
        -- dap_py.resolve_python = resolve_python
        dap_py.test_runner = "pytest"
        -- Modifiying config order
        local dap_py_configs = dap.configurations.python
        local configs = {}
        dap_py_configs[3]["subProcess"] = false
        dap_py_configs[3]["stopOnEntry"] = true
        table.insert(configs, dap_py_configs[3])
        table.insert(configs, dap_py_configs[1])
        table.insert(configs, dap_py_configs[2])
        table.insert(configs, dap_py_configs[4])

        dap.configurations.python = configs

        -- dap.adapters.codelldb = {
        --   type = 'server',
        --   port = "${port}",
        --   executable = {
        --     -- CHANGE THIS to your path!
        --     command = '~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb',
        --     args = {"--port", "${port}"},
        --
        --     -- On windows you may have to uncomment this:
        --     -- detached = false,
        --   }
        -- }
        -- dap.configurations.rust = {
        --     {
        --         name = "Launch",
        --         type = "codelldb",
        --         request = "launch",
        --         -- This is where cargo outputs the executable
        --         program = function ()
        --             -- os.execute("cargo build &> /dev/null")
        --             return vim.api.nvim_buf_get_name(0)
        --             -- return "target/debug/${workspaceFolderBasename}"
        --         end,
        --         args = {"test", "--no-run", "--lib"},
        --         cwd = "${workspaceFolder}",
        --         -- Uncomment if you want to stop at main
        --         -- stopOnEntry = true,
        --         -- MIMode = "gdb",
        --         -- miDebuggerPath = "/usr/bin/gdb",
        --         -- setupCommands = {
        --         --     {
        --         --         text = "-enable-pretty-printing",
        --         --         description = "enable pretty printing",
        --         --         ignoreFailures = false,
        --         --     },
        --         -- },
        --     },
        -- }
        --
        -- dap.configurations.rust = {
        --   {
        --     name = "Launch file",
        --     type = "codelldb",
        --     request = "launch",
        --     program = function()
        --       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        --     end,
        --     cwd = '${workspaceFolder}',
        --     stopOnEntry = false,
        --   },
        --   {
        --     name = "Launch current file",
        --     type = "codelldb",
        --     request = "launch",
        --     program = function()
        --       return vim.api.nvim_buf_get_name(0)
        --     end,
        --     cwd = '${workspaceFolder}',
        --     stopOnEntry = false,
        --   },
        -- {
        --     name = "Debug file",
        --     type= "codelldb",
        --     request= "launch",
        --     cargo= {
        --         args= { "test", "--no-run", "--lib"},      -- Cargo command line to build the debug target
        --                                                     -- "args": ["build", "--bin=foo"] is another possibility
        --         -- The rest are optional
        --         -- env= { RUSTFLAGS= "-Clinker=ld.mold" }, -- Extra environment variables.
        --         -- problemMatcher= "$rustc",                 -- Problem matcher(s) to apply to cargo output.
        --         -- filter= {                                 -- Filter applied to compilation artifacts.
        --         --     name= "mylib",
        --         --     kind= "lib"
        --         -- }
        --     }
        -- }
        -- }
        -- dap.configurations.c = dap.configurations.cpp
        -- dap.configurations.rust = dap.configurations.cpp
        dap.configurations.lua = {
            {
                type = 'nlua',
                request = 'attach',
                name = "Attach to running Neovim instance",
            }
        }

        dap.adapters.nlua = function(callback, config)
            callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
        end

        -- Configuration des signes dap
        local dap_breakpoint = {
            error = {
                text = "🟥",
                texthl = "LspDiagnosticsSignError",
                linehl = "",
                numhl = "",
            },
            rejected = {
                text = "",
                texthl = "LspDiagnosticsSignHint",
                linehl = "",
                numhl = "",
            },
            stopped = {
                text = "⭐️",
                texthl = "LspDiagnosticsSignInformation",
                linehl = "DiagnosticUnderlineInfo",
                numhl = "LspDiagnosticsSignInformation",
            },
        }

        vim.fn.sign_define("DapBreakpoint", dap_breakpoint.error)
        vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
        vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)


        require("nvim-dap-virtual-text").setup {
            commented = true,
        }

        -- Réglage dap UI
        local dap, dapui = require "dap", require "dapui"
        dapui.setup {} -- use default
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
    end
}
