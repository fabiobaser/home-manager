return {
    {
        "folke/persistence.nvim",
        event = "BufReadPre", -- this will only start session saving when an actual file was opened
        opts = {
            -- add any custom options here
        }
    }, {
        "j-hui/fidget.nvim",
        opts = {
            -- options
        }
    }, {
        "alexghergh/nvim-tmux-navigation",
        opts = {},
        lazy = false,
        keys = {
            {
                "<C-h>", function()
                    require("nvim-tmux-navigation").NvimTmuxNavigateLeft()
                end
            }, {
                "<C-j>", function()
                    require("nvim-tmux-navigation").NvimTmuxNavigateDown()
                end
            }, {
                "<C-k>",
                function()
                    require("nvim-tmux-navigation").NvimTmuxNavigateUp()
                end
            }, {
                "<C-l>", function()
                    require("nvim-tmux-navigation").NvimTmuxNavigateRight()
                end
            }
        }
    }
}
