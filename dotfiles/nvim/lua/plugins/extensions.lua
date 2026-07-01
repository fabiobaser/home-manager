return {
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {
			-- add any custom options here
		},
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			-- options
		},
	},{
  'lmilojevicc/herdr-splits.nvim',
  -- or local path during development:
  -- dir = '~/Projects/herdr-splits',
  cond = vim.env.HERDR_ENV == '1',
  event = 'VeryLazy',
  config = function()
    require('herdr-splits').setup({
      -- Defaults shown. All fields optional.
      default_amount = 0.03,       -- Herdr resize ratio
      neovim_amount = 3,           -- Neovim resize cells
      at_edge = 'wrap',            -- 'wrap' | 'stop' | 'split' | function
      ignored_buftypes = { 'nofile', 'quickfix', 'prompt' },
      ignored_filetypes = { 'NvimTree' },
      move_cursor_same_row = false,
      herdr_bin = nil,                -- auto-detected from HERDR_BIN_PATH
    })
  end,
  keys = {
    { '<C-h>', function() require('herdr-splits').move_cursor_left() end,  desc = 'Navigate left' },
    { '<C-j>', function() require('herdr-splits').move_cursor_down() end,  desc = 'Navigate down' },
    { '<C-k>', function() require('herdr-splits').move_cursor_up() end,    desc = 'Navigate up' },
    { '<C-l>', function() require('herdr-splits').move_cursor_right() end, desc = 'Navigate right' },
    { '<M-h>', function() require('herdr-splits').resize_left() end,  desc = 'Resize left' },
    { '<M-j>', function() require('herdr-splits').resize_down() end,  desc = 'Resize down' },
    { '<M-k>', function() require('herdr-splits').resize_up() end,    desc = 'Resize up' },
    { '<M-l>', function() require('herdr-splits').resize_right() end, desc = 'Resize right' },
  },
},
	{
		"alexghergh/nvim-tmux-navigation",
		opts = {},
		lazy = false,
		keys = {
			{
				"<C-h>",
				function()
					require("nvim-tmux-navigation").NvimTmuxNavigateLeft()
				end,
			},
			{
				"<C-j>",
				function()
					require("nvim-tmux-navigation").NvimTmuxNavigateDown()
				end,
			},
			{
				"<C-k>",
				function()
					require("nvim-tmux-navigation").NvimTmuxNavigateUp()
				end,
			},
			{
				"<C-l>",
				function()
					require("nvim-tmux-navigation").NvimTmuxNavigateRight()
				end,
			},
		},
	},
}
