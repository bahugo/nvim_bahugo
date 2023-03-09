local M = {}

local is_windows = function()
    if (string.sub(vim.loop.os_uname().sysname, 1, 3) == "Win") then
        return true
    end
    return false

end

M.is_windows = is_windows

return M
