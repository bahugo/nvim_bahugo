-- Fonction utilitaires
local is_windows = function()
    if (string.sub(vim.loop.os_uname().sysname, 1, 3) == "Win") then
        return true
    end
    return false
end

local get_sep = function()
    if (is_windows())
    then
        return "\\"
    end
    return "/"
end

local get_exe_extension = function()
    if (is_windows())
    then
        return ".exe"
    end
    return ""
end

local get_debubpy_python = function()
    local homedir
    local sep = get_sep()
    local exe = get_exe_extension()
    if (is_windows())
    then
        homedir = os.getenv("LOCALAPPDATA")
    else
        homedir = os.getenv("HOME")
    end
    local python_exe = vim.fn.join(
        { homedir, "nvim-data", "mason", "packages", "debugpy", "venv", "Scripts", "python" .. exe },
        sep)
    return python_exe
end

local resolve_python = function()

    local sep = get_sep()
    local exe = get_exe_extension()
    return os.getenv("CONDA_PREFIX") .. sep .. 'python' .. exe
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
dap.adapters.python = {
    type = 'executable';
    command = get_debubpy_python();
    args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
    {
        type = 'python';
        request = 'launch';
        name = "Launch file";
        program = "${file}";
        pythonPath = resolve_python()
    },
}

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

-- local dap_py = require("dap-python")

-- dap_py.setup(resolve_python())
-- dap_py.setup()
-- dap_py.setup("python")
-- dap_py.test_runner = "pytest"

-- on regle pytest en tant que test runner pour python
-- dap_py.test_runner = "pytest"

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

