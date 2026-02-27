--  _____           _ _             
-- /  __ \         | (_)            
-- | /  \/ ___   __| |_ _ __   __ _ 
-- | |    / _ \ / _` | | '_ \ / _` |
-- | \__/\ (_) | (_| | | | | | (_| |
--  \____/\___/ \__,_|_|_| |_|\__, |
--                             __/ |
--                            |___/ 
--
return {
    {
        "rachartier/tiny-glimmer.nvim",
        event = "VeryLazy",
        priority = 10,
        opts = {}
    },
    {'windwp/nvim-autopairs', event = "InsertEnter", config = true, opts = {}},
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)"
            }, {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)"
            }, {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)"
            }, {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)"
            }, {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)"
            }, {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)"
            }
        }
    }, {
        "kylechui/nvim-surround",
        version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
    }, {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@module 'flash'
        ---@type Flash.Config
        opts = {},
        keys = {
            {
                "s",
                mode = {"n", "x"},
                function() require("flash").jump() end,
                desc = "Flash"
            }, {
                "<M-s>",
                mode = {"n", "x", "o"},
                function() require("flash").treesitter() end,
                desc = "Flash Treesitter"
            }, {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc = "Remote Flash"
            }, {
                "R",
                mode = {"o", "x"},
                function() require("flash").treesitter_search() end,
                desc = "Treesitter Search"
            }, {
                "<c-s>",
                mode = {"c"},
                function() require("flash").toggle() end,
                desc = "Toggle Flash Search"
            }
        }
    }, {
        'numToStr/Comment.nvim',
        enabled = true,
        opts = {
            -- add any options here
        }
    }, {"folke/ts-comments.nvim", opts = {}, event = "VeryLazy"},
    {'folke/todo-comments.nvim', opts = {}}, {
        "lewis6991/gitsigns.nvim",
        event = "BufEnter",
        opts = {},
        keys = {
            {
                '<leader>ghs',
                function() require('gitsigns').stage_hunk() end,
                desc = 'Stage Hunk'
            }, {
                '<leader>ghp',
                function() require('gitsigns').preview_hunk() end,
                desc = "Preview Hunk"
            }, {
                '<leader>ghP',
                function()
                    require('gitsigns').preview_hunk_inline()
                end,
                desc = "Preview Hunk Inline"
            }, {
                '<leader>ghr',
                function() require('gitsigns').reset_hunk() end,
                desc = "Reset Hunk"
            }
        }
    }, {"danymat/neogen", config = true}, {
        'nvim-pack/nvim-spectre',
	config= function ()
	require("spectre").setup({
		open_cmd = "vnew",
		use_trouble_qf = true
	})	
		end,
        keys = {
            {"<leader>mr", function()
                require('spectre').open_file_search()
            end}, {"<leader>mR", function()
                require('spectre').toggle()
            end}
        }
    }, {
        "HiPhish/rainbow-delimiters.nvim",
        config = function()
            require('rainbow-delimiters.setup').setup {
                query = {tsx = "rainbow-parens"}
            }
        end
    }, {
        "ThePrimeagen/harpoon",
        keys = {
            {
                '<leader>jh',
                function()
                    require('harpoon.ui').toggle_quick_menu()
                end,
                desc = "Show Harpoon Menu"
            }, {
                '<leader>jH',
                function() require('harpoon.mark').add_file() end,
                desc = "Add Harpoon Mark"
            }
        }
    },
{
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
        local mc = require("multicursor-nvim")
        mc.setup()

        local set = vim.keymap.set

        -- Add or skip cursor above/below the main cursor.
        set({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end)
        set({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end)
        set({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end)
        set({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end)

        -- Add or skip adding a new cursor by matching word/selection
        set({"n", "x"}, "<leader>n", function() mc.matchAddCursor(1) end)
        set({"n", "x"}, "<leader>s", function() mc.matchSkipCursor(1) end)
        set({"n", "x"}, "<leader>N", function() mc.matchAddCursor(-1) end)
        set({"n", "x"}, "<leader>S", function() mc.matchSkipCursor(-1) end)

        -- Add and remove cursors with control + left click.
        set("n", "<c-leftmouse>", mc.handleMouse)
        set("n", "<c-leftdrag>", mc.handleMouseDrag)
        set("n", "<c-leftrelease>", mc.handleMouseRelease)

        -- Disable and enable cursors.
        set({"n", "x"}, "<c-q>", mc.toggleCursor)

        -- Mappings defined in a keymap layer only apply when there are
        -- multiple cursors. This lets you have overlapping mappings.
        mc.addKeymapLayer(function(layerSet)

            -- Select a different cursor as the main one.
            layerSet({"n", "x"}, "<left>", mc.prevCursor)
            layerSet({"n", "x"}, "<right>", mc.nextCursor)

            -- Delete the main cursor.
            layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

            -- Enable and clear cursors using escape.
            layerSet("n", "<esc>", function()
                if not mc.cursorsEnabled() then
                    mc.enableCursors()
                else
                    mc.clearCursors()
                end
            end)
        end)

        -- Customize how cursors look.
        local hl = vim.api.nvim_set_hl
        hl(0, "MultiCursorCursor", { reverse = true })
        hl(0, "MultiCursorVisual", { link = "Visual" })
        hl(0, "MultiCursorSign", { link = "SignColumn"})
        hl(0, "MultiCursorMatchPreview", { link = "Search" })
        hl(0, "MultiCursorDisabledCursor", { reverse = true })
        hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
    end
}
}
