require("hardtime").setup(
        {
            disable_mouse = false,
            max_time=1000,
            max_count =5,
            hint=true,
            notification=true,
            disabled_keys ={
                ["<Up>"] = {},
                ["<Down>"] = {},
                ["<Left>"] = {},
                ["<Right>"] = {},
            },
    })
