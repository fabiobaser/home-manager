return {
    {
        "nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	branch = "main",
        main = "nvim-treesitter",
        ---@module "nvim-treesitter"
	config = function() 
	require('nvim-treesitter').install(
	{
	    	-- Web / React
                "typescript", "javascript", "tsx", "css", "html", "json", "json5", "scss",
                -- "comment", -- comments are slowing down TS bigtime, so disable for now

		-- Neovim
		"vim", "vimdoc", "lua",

		-- Shell
		"bash", "nix",

		-- General
                 "git_config", "gitcommit", "gitignore", "http", "markdown", "markdown_inline", "regex", "query", "yaml", "toml"
            })
	end,
init = function()
  vim.api.nvim_create_autocmd('FileType', { 
    callback = function() 
      -- Enable treesitter highlighting and disable regex syntax
      pcall(vim.treesitter.start) 
      -- Enable treesitter-based indentation
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" 
    end, 
  }) 
end,
    }, {"fei6409/log-highlight.nvim", event = "BufRead *.log", opts = {}}
}
