return {
    --[[ {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons" -- optional, but recommended
        },
        lazy = false, -- neo-tree will lazily load itself
        ---@module 'neo-tree'
        ---@type neotree.Config
        opts = {
            close_if_last_window = true,
            filesystem = {
                follow_current_file = {enabled = true, leave_dirs_open = false}
            }

        }
        -- keys = {{"<leader>e", "<Cmd>Neotree filesystem reveal left<CR>"}}
    } ]]
}
