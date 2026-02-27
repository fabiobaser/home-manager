return {

    --[[ {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {

      left = {
        -- Neo-tree filesystem always takes half the screen height
        {
          title = "Explorer",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          size = { height = 0.5 },
        },
        {
          title = "Git Status",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "git_status"
          end,
          pinned = true,
          collapsed = true, -- show window as closed/collapsed on start
          open = "Neotree position=right git_status",
        },
        -- any other neo-tree windows
        "neo-tree",
      },
      right = {
        {
          title = function()
            local buf_name = vim.api.nvim_buf_get_name(0) or "[No Name]"
            return vim.fn.fnamemodify(buf_name, ":t")
          end,
          ft = "Outline",
          pinned = true,
          open = "SymbolsOutlineOpen",
        }
      },
      bottom = {
        "Trouble",
        {
          ft = "help",
          size = { height = 20 },
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
      }
    }
  } ]]
}
