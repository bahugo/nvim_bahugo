return {
    'numToStr/Comment.nvim',         -- "gc" to comment visual regions/lines
    -- Enable Comment.nvim
    config = function()
        require('Comment').setup()
    end,
    lazy = false
}
