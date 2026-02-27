return {
    {
        "nvim-treesitter/nvim-treesitter",
	branch = "master",
        main = "nvim-treesitter.configs",
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
        }
    }, {"fei6409/log-highlight.nvim", event = "BufRead *.log", opts = {}}
}
