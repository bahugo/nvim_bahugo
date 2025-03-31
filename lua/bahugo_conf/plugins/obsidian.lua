return {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   "BufReadPre path/to/my-vault/**.md",
    --   "BufNewFile path/to/my-vault/**.md",
    -- },
    dependencies = {
        -- Required.
        "nvim-lua/plenary.nvim",

        -- see below for full list of optional dependencies 👇
    },
    config = function()
        local path = require("plenary.path")
        local obsidian_vault_root
        if (require("bahugo_conf.utils").is_windows()) then
            obsidian_vault_root = path:new(os.getenv("LOCALAPPDATA"), ".vaults")
        else
            obsidian_vault_root = path:new(os.getenv("HOME"), ".vaults")
        end

        if (obsidian_vault_root:exists()) then
            require("obsidian").setup(
                {
                    {
                        name = "personal",
                        path = path:new(obsidian_vault_root, "personal"),
                    },
                    {
                        name = "work",
                        path = path:new(obsidian_vault_root, "work"),
                    },
                })
        end
        -- see below for full list of options 👇
    end,

}
