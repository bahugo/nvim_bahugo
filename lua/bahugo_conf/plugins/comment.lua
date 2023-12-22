return {
    'numToStr/Comment.nvim',         -- "gc" to comment visual regions/lines
    event = { "BufReadPre", "BufNewFile" },
    -- Enable Comment.nvim
    config = function()
        require('Comment').setup()
        local ft = require('Comment.ft')
        -- 1. Using set function
        ft
        -- Set only line comment
        .set('qmljs', '//%s')
    end,
    lazy = false
}
