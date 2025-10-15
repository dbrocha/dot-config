return {
    {
        "catppuccin/nvim",
        lazy = false,
        name = "catppuccin",
        priority = 1000,
    },
    -- { "ellisonleao/gruvbox.nvim" },
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    -- },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "catppuccin-frappe",
            -- colorscheme = "gruvbox",
        },
    },
}
