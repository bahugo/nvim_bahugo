local path = require("plenary.path")

-- Fonction utilitaires
local is_windows = require("bahugo_conf.utils").is_windows

local get_exe_extension = function()
    if (is_windows())
    then
        return ".exe"
    end
    return ""
end

local get_debubpy_python = function()
    local python_exe
    if (is_windows())
    then
        python_exe = path:new(os.getenv("LOCALAPPDATA"), "nvim-data", "mason", "packages",
        "debugpy", "venv", "Scripts", "python.exe")
    else
        python_exe = path:new(os.getenv("HOME"), ".local","share","nvim", "mason", "packages",
        "debugpy", "venv", "bin", "python")
    end
    if not path.exists(python_exe) then
        vim.notify("debugpy introuvable, vérifier qu'il a bien été installé avec mason :"
        .. python_exe.filename, vim.log.levels.WARN )
    end
    return python_exe.filename
end

local resolve_python = function()
    local exe = get_exe_extension()
    return path:new(os.getenv("CONDA_PREFIX"), 'python' .. exe).filename
end

local dap = require('dap')

-- set des keymap
vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = "DAP continue" })
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end, { desc = "DAP step over" })
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end, { desc = "DAP step into" })
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end, { desc = "DAP step out" })
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end,
    { desc = "DAP toggle breakpoint" })
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end,
    { desc = "DAP set breakpoint" })
vim.keymap.set('n', '<Leader>lp',
    function()
        require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end,
    { desc = "DAP set breakpoint with message" })
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end,
    { desc = "DAP repl open" })
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end,
    { desc = "DAP run last" })
vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
    require('dap.ui.widgets').hover()
end, { desc = "DAP hover" })
vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
    require('dap.ui.widgets').preview()
end, { desc = "DAP preview" })
vim.keymap.set('n', '<Leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end, { desc = "DAP frames" })
vim.keymap.set('n', '<Leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end, { desc = "DAP scopes" })

local dap_py = require("dap-python")
dap_py.setup(get_debubpy_python())
dap_py.resolve_python = resolve_python
dap_py.test_runner = "pytest"
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    -- CHANGE THIS to your path!
    command = '~/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb',
    args = {"--port", "${port}"},

    -- On windows you may have to uncomment this:
    -- detached = false,
  }
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
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

