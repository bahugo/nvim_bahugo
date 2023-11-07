return {
    'numToStr/Comment.nvim',         -- "gc" to comment visual regions/lines
    event = { "BufReadPre", "BufNewFile" },
    -- Enable Comment.nvim
    config = function()
        require('Comment').setup()
    end,
    lazy = false
}
