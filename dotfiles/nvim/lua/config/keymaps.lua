--  _   __
-- | | / /
-- | |/ /  ___ _   _ _ __ ___   __ _ _ __  ___
-- |    \ / _ \ | | | '_ ` _ \ / _` | '_ \/ __|
-- | |\  \  __/ |_| | | | | | | (_| | |_) \__ \
-- \_| \_/\___|\__, |_| |_| |_|\__,_| .__/|___/
--              __/ |               | |
--             |___/                |_|
--
--
---@module 'snacks'
---@type Snacks
Snacks = Snacks

Snacks.keymap.set("n", "<leader>s", ":w<cr>")
Snacks.keymap.set("n", "<leader>q", ":q<cr>", {desc = "Quit"})
Snacks.keymap.set("n", "<leader>Q", ":qall<cr>", {desc = "Quit All"})
Snacks.keymap.set("n", "<leader>h", ":nohl<cr>", {desc = "Quit All"})
Snacks.keymap.set("t", "<Esc>", "<C-\\><C-n>",
                  {desc = "Exit Insert Mode (Terminal)"})

Snacks.keymap.set("n", "<leader>Nii", "<Cmd>Inspect<cr>",
                  {desc = "[N]eovoim [I]nspect"})
Snacks.keymap.set("i", "<C-k>", function()
    local cmp = require('blink.cmp')
    local item = cmp.get_selected_item and cmp.get_selected_item()
    print(vim.inspect(item))
end, {desc = "Inspect Blink"})

-- Snacks.keymap.set("n", "<C-h>", "<C-w>h")
-- Snacks.keymap.set("n", "<C-j>", "<C-w>j")
-- Snacks.keymap.set("n", "<C-k>", "<C-w>k")
-- Snacks.keymap.set("n", "<C-l>", "<C-w>l")

Snacks.keymap.set("n", "<M-j>", "<Cmd>m .+1<CR>")
Snacks.keymap.set("n", "<M-k>", "<Cmd>m .-2<CR>")

Snacks.keymap.set("n", "<leader>Ss",
                  function() require('persistence').select() end)
Snacks.keymap.set("n", "<leader>S.",
                  function() require('persistence').load() end)
Snacks.keymap.set("n", "<leader>Sl",
                  function() require('persistence').load({last = true}) end)

Snacks.keymap.set("n", "<leader>ns", function()

    local on_confirm = function(value)
        if value == nil then return end

        vim.cmd(
            "edit ~/Developer/collector-frontend/packages/api/src/schemas/" ..
                value .. ".ts")
    end

    Snacks.input
        .input({prompt = "Schema Name", completion = "moin"}, on_confirm)
end, {desc = "Create a new Schema File"})

local custom_picker = function()
    Snacks.picker.pick({
        prompt = "Generator Name ",
        finder = function()
            return {
                {idx = 1, text = "Schema", icon = "", fabio = "1"},
                {idx = 2, text = "hi", icon = "", fabio = "2"}
            }
        end,
        format = function(item, _)
            local file = item.text
            local ret = {}
            local a = Snacks.picker.util.align
            ret[#ret + 1] = {a(item.icon, 3)}
            ret[#ret + 1] = {" "}
            ret[#ret + 1] = {a(file, 20)}

            return ret
        end,
        layout = {
            layout = {
                preview = false,
                box = "horizontal",
                width = 0.5,
                height = 0.5,
                {
                    box = "vertical",
                    border = "rounded",
                    title = "Find directory",
                    {win = "input", height = 1, border = "bottom"},
                    {win = "list", border = "none"}
                }
            }
        },
        confirm = function(picker, item)
            picker:close()
            Snacks.input.input({prompt = "Name"}, print)
        end
    })
end

Snacks.keymap.set("n", "<leader>nn", function() custom_picker() end)

local special_finder_picker = function()
    Snacks.picker.pick({
        prompt = "Find ",
        finder = function()
            return {
                {
                    idx = 1,
                    text = "in Modules",
                    icon = "",
                    onSelect = function()
                        Snacks.picker.files({
                            cwd = "~/Developer/collector-frontend/apps/web/src/modules/"
                        })
                    end
                }, {
                    idx = 2,
                    text = "API Schema",
                    icon = "",
                    onSelect = function()
                        Snacks.picker.files({
                            cwd = "~/Developer/collector-frontend/packages/api/src/schemas/"
                        })
                    end
                }, {
                    idx = 3,
                    text = "API Contract",
                    icon = "",
                    onSelect = function()
                        Snacks.picker.files({
                            cwd = "~/Developer/collector-frontend/packages/api/src/contracts/"
                        })
                    end
                }, {
                    idx = 4,
                    text = "API Service",
                    icon = "",
                    onSelect = function()
                        Snacks.picker.files({
                            cwd = "~/Developer/collector-frontend/apps/web/src/features/api/services/"
                        })
                    end
                }

            }
        end,
        format = function(item, _)
            local file = item.text
            local ret = {}
            local a = Snacks.picker.util.align
            ret[#ret + 1] = {a(item.icon, 3)}
            ret[#ret + 1] = {" "}
            ret[#ret + 1] = {a(file, 20)}

            return ret
        end,
        layout = {
            layout = {
                preview = false,
                box = "horizontal",
                width = 0.5,
                height = 0.5,
                {
                    box = "vertical",
                    border = "rounded",
                    title = "Find directory",
                    {win = "input", height = 1, border = "bottom"},
                    {win = "list", border = "none"}
                }
            }
        },
        confirm = function(picker, item)
            picker:close()
            item.onSelect()
        end
    })
end

Snacks.keymap.set("n", "<leader>FF", special_finder_picker,
                  {desc = "Opens Special Finder Picker"})

Snacks.keymap.set("n", "<leader>EE", function()

    Snacks.picker.pick({
        prompt = "Find ",
        finder = function()
            return {
                {
                    idx = 1,
                    text = "Routes",
                    onSelect = function()
                        Snacks.explorer({
                            cwd = "~/Developer/collector-frontend/apps/web/src/routes/"
                        })
                    end
                }
            }
        end,
        format = function(item, _)
            local file = item.text
            local ret = {}
            local a = Snacks.picker.util.align
            ret[#ret + 1] = {" "}
            ret[#ret + 1] = {a(file, 20)}

            return ret
        end,
        layout = {
            layout = {
                preview = false,
                box = "horizontal",
                width = 0.5,
                height = 0.5,
                {
                    box = "vertical",
                    border = "rounded",
                    title = "Find directory",
                    {win = "input", height = 1, border = "bottom"},
                    {win = "list", border = "none"}
                }
            }
        },
        confirm = function(picker, item)
            picker:close()
            item.onSelect()
        end
    })
end, {desc = "Opens Scoped Explorers"})
