return {
    {
        "nvim-treesitter/nvim-treesitter",
	branch = "main",
        main = "nvim-treesitter",
        ---@module "nvim-treesitter"
        opts = {
            highlight = {enable = true},
            folds = {enable = true},
            ensure_installed = {
                "typescript", "javascript", "tsx",
                -- "comment", -- comments are slowing down TS bigtime, so disable for now
                "css", "gitcommit", "gitignore", "graphql", "http", "nix",
                "scss"
            }
        },
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
