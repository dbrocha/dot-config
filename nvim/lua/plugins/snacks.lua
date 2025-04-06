return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        dashboard = {
            sections = {
                {
                    section = "terminal",
                    cmd = "chafa ~/.config/handsome_squidward.png --format symbols --symbols vhalf --size 40x40; sleep .1",
                    height = 17,
                    padding = 1,
                },
                {
                    pane = 2,
                    { section = "keys", gap = 1, padding = 1 },
                    { section = "startup" },
                },
            },
        },
    },
}
