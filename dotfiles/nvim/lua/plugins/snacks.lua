return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@module "snacks"
        ---@type snacks.Config
        opts = {
            statuscolumn = {
                left = {"mark", "sign"},
                right = {"fold", "git"},
                folds = {open = true},
                git = {patterns = {"GitSigns", "MiniDiffSign"}}
            },
            notifier = {sort = {"added"}},
            scroll = {debug = false},
            image = {
                force = false,
                enabled = true,
                debug = {request = false, convert = false, placement = false},
                math = {enabled = true},
                doc = {inline = true, float = true}
            },
            picker = {
                previewers = {diff = {builtin = false}, git = {builtin = false}},
                sources = {
                    custom_picker = {},
                    files = {hidden = true},
                    grep = {hidden = true},
                    select = {
                        kinds = {
                            sidekick_cli = {layout = {preset = "vscode"}},
                            sidekick_prompt = {layout = {preset = "vscode"}}
                        }
                    },
                    explorer = {auto_close = true, hidden = false}
                },
                win = {
                    input = {
                        keys = {
                            ["<c-l>"] = {"toggle_lua", mode = {"n", "i"}},
                            ["v"] = {"edit_vsplit", mode = {"n"}},
                            ["s"] = {"edit_split", mode = {"n"}},
                            ["<c-q>"] = {"qflist", mode = {"n", "i"}},
                            ["d"] = {"bufdelete", mode = {"n"}}
                        }
                    }
                },
                actions = {
                    toggle_lua = function(p)
                        local opts = p.opts --[[@as snacks.picker.grep.Config]]
                        opts.ft = not opts.ft and "lua" or nil
                        p:find()
                    end
                }
            },
            words = {notify_jump = true, notify_end = true},
            indent = {
                priority = 1,
                enabled = true,
                only_scope = false,
                only_current = true,
                chunk = {enabled = true},
                hl = 'SnacksIndent'
            },
            dashboard = {
                sections = {
                    {section = "header"},
                    {section = "keys", gap = 1, padding = 1}, {
                        pane = 2,
                        icon = " ",
                        title = "Recent Files",
                        section = "recent_files",
                        indent = 2,
                        padding = 1
                    }, {
                        pane = 2,
                        icon = " ",
                        title = "Projects",
                        section = "projects",
                        indent = 2,
                        padding = 1
                    }, {
                        pane = 2,
                        icon = " ",
                        title = "Git Status",
                        section = "terminal",
                        enabled = function()
                            return Snacks.git.get_root() ~= nil
                        end,
                        cmd = "git status --short --branch --renames",
                        height = 5,
                        padding = 1,
                        ttl = 5 * 60,
                        indent = 3
                    }, {section = "startup"}
                }
            },
            toggle = {which_key = true}
        },
        -- stylua: ignore
        keys = {
            {
                "<leader><space>",
                function() Snacks.picker.smart() end,
                desc = "Smart Open"
            },
            {
                "<leader>e",
                function() Snacks.picker.explorer() end,
                desc = "Open Explorer"
            },
            -- { "<leader>e",       function() Snacks.explorer.open() end,          desc = "Open Explorer" },
            {
                "<leader>,",
                function() Snacks.picker.buffers() end,
                desc = "Pick Buffer"
            }, {
                "<leader>:",
                function() Snacks.picker.command_history() end,
                desc = "Command history"
            },
            {
                "<leader>ff",
                function() Snacks.picker.files({}) end,
                desc = "Find files"
            },
            {
                "<leader>fg",
                function() Snacks.picker.grep({}) end,
                desc = "Find text"
            },
            {
                "<leader>fb",
                function() Snacks.picker.buffers({}) end,
                desc = "Find buffers"
            },
            {
                "<leader>fe",
                function() Snacks.picker.recent({}) end,
                desc = "Find recent"
            },
            {
                "<leader>fp",
                function() Snacks.picker.pickers() end,
                desc = "Find Picker"
            }, {
                "<leader>fis",
                function()
                    Snacks.picker.grep({
                        cwd = "~/Developer/sorz/packages/api/src/schemas/"

                    })
                end,
                desc = "Find in Schemas"
            }, {
                "<leader>lfi",
                function() Snacks.picker.lsp_implementations() end,
                desc = "Find LSP Implementations"
            }, {
                "<leader>lfr",
                function() Snacks.picker.lsp_references() end,
                desc = "Find LSP References"
            }, {
                "<leader>c",
                function() Snacks.bufdelete() end,
                desc = "Closes current buffer"
            }, {
                "<leader>Ca",
                function() Snacks.bufdelete.other() end,
                desc = "Closes all other buffers"
            }, -- git
            {"<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit"},
            {
                "<leader>gl",
                function() Snacks.picker.git_log() end,
                desc = "Git Log"
            },
            {
                "<leader>gs",
                function() Snacks.picker.git_status() end,
                desc = "Git Status"
            }, {
                "<leader>gd",
                function() Snacks.picker.git_diff() end,
                desc = "Git Diff (Hunks)"
            }, {
                "<leader>T",
                function()

                    local clients = vim.lsp.get_clients({name = "vtsls"})

                    local root_dir = clients[1].config.root_dir

                    Snacks.scratch({
                        icon = " ",
                        name = "Todo",
                        ft = "markdown",
                        file = root_dir .. "/TODO.md"
                    })

                end,
                desc = "Neovim Todo List"
            }, {
                "<leader>NT",
                function()
                    local file = vim.uv.fs_stat("TODO.md") and "TODO.md" or
                                     "~/.config/nvim/TODO.md"
                    Snacks.scratch({
                        icon = " ",
                        name = "Todo",
                        ft = "markdown",
                        file = file
                    })
                end,
                desc = "Neovim Todo List"
            }, {
                "<leader>Nl",
                function() Snacks.picker.lazy() end,
                desc = "Search for Neovim Plugin"
            }, {
                "[[",
                function() Snacks.words.jump(-1, true) end,
                desc = "Jump to prev LSP Word"
            }, {
                "]]",
                function() Snacks.words.jump(1, true) end,
                desc = "Jump to next LSP Word"
            }
        }
    }
}
