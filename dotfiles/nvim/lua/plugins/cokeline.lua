return {{
		"willothy/nvim-cokeline",
		config = function()
			local is_picking_focus = require("cokeline.mappings").is_picking_focus
			local is_picking_close = require("cokeline.mappings").is_picking_close
			local palette = require("catppuccin.palettes").get_palette("mocha")

			require("cokeline").setup({
				default_hl = {
					fg = function(buf)
						return buf.is_focused and palette.base or palette.text
					end,
					bg = function(buf)
						return buf.is_focused and palette.subtext1 or palette.base
					end,
				},
				sidebar = {
					filetype = "neo-tree",
					components = {
						{
							text = "    Fabio's Neovim",
							fg = function(buf)
								return buf.is_focused and palette.base or palette.text
							end,
							bg = function(buf)
								return buf.is_focused and palette.text or palette.base
							end,
							style = "bold",
						},
					},
				},
				components = {
					{ text = "  " },
					{
						text = function(buffer)
							return (is_picking_focus() or is_picking_close()) and buffer.pick_letter .. " "
								or buffer.devicon.icon
						end,
						fg = function(buffer)
							return (is_picking_focus() and palette.peach)
								or (is_picking_close() and palette.red)
								or buffer.devicon.color
						end,
						style = function(_)
							return (is_picking_focus() or is_picking_close()) and "italic,bold" or nil
						end,
					},
					{
						text = function(buffer)
							return buffer.filename
						end,
						style = "italic",
					},

					{
						text = function(buffer)
							return buffer.is_modified and " *" or ""
						end,
					},
					{ text = "  " },
				},
			})
		end,
		keys = {
			{
				"<S-h>",
				function()
					require("cokeline.mappings").by_step("focus", -1)
				end,
			},
			{
				"<S-l>",
				function()
					require("cokeline.mappings").by_step("focus", 1)
				end,
			},
			{
				"<leader>xf",
				function()
					require("cokeline.mappings").pick("focus")
				end,
			},
			{
				"<leader>xc",
				function()
					require("cokeline.mappings").pick("close")
				end,
			},
		},
	}}
