require('dap-python').resolve_python = function()
    local env_name = "PATROVIEW"
    local conda_env_path_win = {
        "C:\\ProgramData\\Anaconda3\\envs\\", "C:\\ProgramData\\Miniconda3\\envs\\",
        "C:\\Anaconda3\\envs\\", "C:\\Miniconda3\\envs\\",
}

local base_env_path = ""
for dir_path in conda_env_path_win do
    -- retenir le path s'il existe
    if vim.fn.isdirectory(dir_path) then
        base_env_path = dir_path
    end
end
  return base_env_path .. env_name
end
