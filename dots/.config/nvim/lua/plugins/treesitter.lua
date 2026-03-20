return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    opts = {
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
    },
}
