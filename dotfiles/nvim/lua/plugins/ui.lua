return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                auto_integrations = true,
                flavour = "macchiato",
                custom_highlights = function(colors)
                    return {
                        Normal = {bg = colors.base},
                        typescriptPredefinedType = {fg = colors.mauve},
                        Keyword = {fg = colors.mauve, style = {'bold'}}
                    }
                end
            })

            vim.cmd.colorscheme "catppuccin"
        end
    }, {
        "folke/which-key.nvim",
        dependencies = {"nvim-mini/mini.icons", "nvim-tree/nvim-web-devicons"},
        event = "VeryLazy",
        ---@module 'which-key'
        ---@type wk.Opts
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            preset = 'modern',
            notify = true,
            icons = {keys = {}},
            disable = {ft = {'spectre_panel'}}
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({global = false})
                end,
                desc = "Buffer Local Keymaps (which-key)"
            }
        }
    }, {
        "folke/noice.nvim",
	event = "VeryLazy",
        opts = {
            -- add any options here
            lsp = {
                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true -- requires hrsh7th/nvim-cmp
                }
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true, -- use a classic bottom cmdline for search
                command_palette = true, -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = false, -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false -- add a border to hover docs and signature help
            }
        },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim", -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            "rcarriga/nvim-notify"
        }
    }, {
        'nvim-lualine/lualine.nvim',
        dependencies = {'nvim-tree/nvim-web-devicons' },
        ---@module "lualine"
	config = function() 
		require('lualine').setup({
            sections = {
                lualine_a = {"mode"},
                lualine_b = {'branch', "diff", "diagnostics"},
                lualine_c = {
                    'filename', {
                        function() require("noice").api.status.search.get() end,
                        cond =function() require("noice").api.status.search.has() end,
                        color = {fg = "#ff9e64"}
                    }
                },
                lualine_x = {
                    {
                        function()require("noice").api.status.mode.get() end,
                        cond = function()require("noice").api.status.mode.has() end,
                        color = {fg = "#ff9e64"}
                    }
                },
                lualine_y = {'lsp_status', 'filetype'},
                lualine_z = {"location"}
            }
        })	
	end,
    }, {
        "Bekaboo/dropbar.nvim",
        event = "BufEnter",
        ---@module "dropbar"
        ---@type dropbar_configs_t
        opts = {
            bar = {
                sources = function(buf, _)
                    local sources = require('dropbar.sources')
                    local utils = require("dropbar.utils")

                    return {
                        utils.source.fallback({sources.lsp, sources.treesitter})
                    }
                end
            }
        },
        keys = {{"x", function() require('dropbar.api').pick() end}}
    }
}
