return {
    {
        "mfussenegger/nvim-dap-python",
        config = function()
            require("dap-python").setup("python")
            local dap = require("dap")
            local existing_configs = dap.configurations.python or {}

            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Debug this file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                    env = {
                        PYTHONPATH = "${workspaceFolder}",
                    },
                },
            }
            for _, config in ipairs(existing_configs) do
                table.insert(dap.configurations.python, config)
            end
        end,
    },
}
