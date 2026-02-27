if vim.env.VSCODE then vim.g.vscode = true end

if vim.loader then vim.loader.enable() end

function _G.Capitalize(str) return (str:gsub("^%1", string.upper)) end


require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.registers")

vim.api.nvim_command("highlight SnacksIndent guifg=#493d64")


vim.api.nvim_create_autocmd("FileType", {
	pattern = {'typescript', 'typescriptreact', 'json', 'jsonc', 'css', 'yaml'},
	callback = function ()
		
		vim.treesitter.start()

		vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		vim.wo[0][0].foldmethod = 'expr'
		
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
})
