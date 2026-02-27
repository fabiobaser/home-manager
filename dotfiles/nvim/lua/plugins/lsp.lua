--  _      ___________ 
-- | |    /  ___| ___ \
-- | |    \ `--.| |_/ /
-- | |     `--. \  __/ 
-- | |____/\__/ / |    
-- \_____/\____/\_|    
return {
    {
        "neovim/nvim-lspconfig",
        config = function()

            --[[ vim.lsp.config['ts_go_ls'] = {
                cmd = {"pnpm", "tsgo", "--lsp", "--stdio"},
                filetypes = {
                    "javascript", "javascriptreact", "typescript",
                    "typescriptreact"
                },
                root_markers = {'tsconfig.json', 'package.json', ".git"}
            }
            vim.lsp.enable('ts_go_ls') ]]

            vim.lsp.config['jsonls'] = {
                settings = {
                    json = {
                        schemas = {
                            {
                                fileMatch = {"package.json"},
                                url = "https://json.schemastore.org/package.json"
                            }, {
                                fileMatch = {"tsconfig.json", "tsconfig.*.json"},
                                url = "https://json.schemastore.org/tsconfig"
                            },
                            {
                                fileMatch = {"turbo.json"},
                                url = "https://turborepo.com/schema.json"
                            }, {
                                fileMatch = {'biome.json', "biome.jsonc"},
                                url = "https://biomejs.dev/schemas/latest/schema.json"
                            }
                        }
                    }
                }
            }

            vim.lsp.config['tailwindcss'] = {
                settings = {
                    tailwindCSS = {
                        emmetCompletions = true,
                        classFunctions = {"tv", "cva", "clsx"},
                        classAttributes = {
                            "class", "className", "class:list", "classList",
                            "ngClass"
                        },
                        includeLanguages = {
                            eelixir = "html-eex",
                            elixir = "phoenix-heex",
                            eruby = "erb",
                            heex = "phoenix-heex",
                            htmlangular = "html",
                            templ = "html"
                        },
                        lint = {
                            cssConflict = "warning",
                            invalidApply = "error",
                            invalidConfigPath = "error",
                            invalidScreen = "error",
                            invalidTailwindDirective = "error",
                            invalidVariant = "error",
                            recommendedVariantOrder = "warning"
                        },
                        validate = true
                    }
                }
            }

        end
    }, {
        "mason-org/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                handlers = {

                    -- Specific handler for vtsls
                    ['vtsls'] = function()
                        local capabilities = vim.lsp.protocol
                                                 .make_client_capabilities()
                        -- Get blink.cmp capabilities if available
                        local has_blink, blink = pcall(require, 'blink.cmp')
                        if has_blink then
                            capabilities =
                                blink.get_lsp_capabilities(capabilities)
                        end
                        -- Remove signature help capability
                        capabilities.textDocument.signatureHelp = nil

                        require('lspconfig').vtsls.setup({
                            capabilities = capabilities,
                            settings = {
                                typescript = {
                                    inlayHints = {
                                        parameterNames = {enabled = "none"},
                                        parameterTypes = {enabled = false},
                                        variableTypes = {enabled = false},
                                        propertyDeclarationTypes = {
                                            enabled = false
                                        },
                                        functionLikeReturnTypes = {
                                            enabled = false
                                        },
                                        enumMemberValues = {enabled = false}
                                    }
                                },
                                javascript = {
                                    inlayHints = {
                                        parameterNames = {enabled = "none"},
                                        parameterTypes = {enabled = false},
                                        variableTypes = {enabled = false},
                                        propertyDeclarationTypes = {
                                            enabled = false
                                        },
                                        functionLikeReturnTypes = {
                                            enabled = false
                                        },
                                        enumMemberValues = {enabled = false}
                                    }
                                }
                            }
                        })
                    end
                }
            })
        end,
        dependencies = {{"mason-org/mason.nvim", opts = {}}}
    }, {
        "nvimdev/lspsaga.nvim",
        ---@module 'lspsaga'
        ---@type LspsagaConfig
        opts = {lightbulb = {sign = false}},
        dependencies = {
            "nvim-tree/nvim-web-devicons" -- optional
        },
        keys = {
            {"K", ":Lspsaga show_cursor_diagnostics<cr>"},
            {"<leader>k", ":Lspsaga hover_doc<cr>"},
            {"<leader>lr", ":Lspsaga rename<cr>"},
            {"<leader>lff", ":Lspsaga finder<cr>"},
            {"<leader>la", ":Lspsaga code_action<cr>"},
            {"<leader>ld", ":Lspsaga goto_definition<cr>"},
            {"<leader>lt", ":Lspsaga goto_type_definition<cr>"}
        }
    }, {
        "stevearc/conform.nvim",
        event = {"BufWritePre"},
        cmd = {"ConformInfo"},
        ---@type conform.setupOpts
        opts = {
            notify_no_formatters = true,
            format_on_save = {lsp_format = "never"},
            formatters_by_ft = {
                lua = {"lua-format"},
                javascript = {"biome", "biome-organize-imports"},
                javascriptreact = {"biome", "biome-organize-imports"},
                typescript = {"biomeFix"},
                typescriptreact = {"biomeFix"},
                json = {"biomeFix"}
            },
            formatters = {
                biomeFix = {
                    stdin = true,
                    command = "biome",
                    args = {
                        "check", "--write", "--stdin-file-path", "$FILENAME"
                    }
                }
            }
        }
    }, {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {library = {"snacks.nvim", 'vim'}}
    }, {
        'L3MON4D3/LuaSnip',
        version = "v2.*",
        build = "make install_jsregexp",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load({
                paths = "~/.config/nvim/lua/snippets"
            })
            require("luasnip.loaders.from_snipmate").lazy_load({
                paths = "~/.config/nvim/lua/snippets"
            })
        end
    },
    { -- optional blink completion source for require statements and module annotations
        "saghen/blink.cmp",
        event = "BufReadPre",
        version = "1.*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            snippets = {preset = "luasnip"},
            completion = {
                documentation = {auto_show = true},
                menu = {
                    draw = {
                        treesitter = {'lsp'},
                        columns = {
                            {"kind_icon", gap = 2},
                            {'label', 'label_description', "kind", gap = 2}
                        }
                    }
                }
            },
            keymap = {
                preset = "default",
                ["<Enter>"] = {"select_and_accept", "fallback"}
            },
            signature = {},
            sources = {
                -- add lazydev to your completion providers
                default = {"lazydev", "lsp", "path", "snippets"},
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100
                    }
                }
            }
        },
        keys = {
            {'<C-k>', function() require('blink.cmp').show() end, mode = 'i'}
        }
    }, {"ThePrimeagen/refactoring.nvim", opts = {}},
    {"vuki656/package-info.nvim", opts = {}}
}
