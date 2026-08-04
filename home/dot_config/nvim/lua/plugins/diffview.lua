return {
  {
    "sindrets/diffview.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },

    -- Lazy-load on command or keymaps
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
    },

    keys = {
      -- Toggle repo diff view
      {
        "<leader>gd",
        function()
          local lib = require("diffview.lib")
          if next(lib.views) == nil then
            vim.cmd("DiffviewOpen")
          else
            vim.cmd("DiffviewClose")
          end
        end,
        desc = "Diffview: Toggle",
      },

      -- File history for current file
      {
        "<leader>gh",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "Diffview: File History (current file)",
      },

      -- File history for repo
      {
        "<leader>gH",
        "<cmd>DiffviewFileHistory<cr>",
        desc = "Diffview: File History (repo)",
      },
    },

    config = function()
      require("diffview").setup({})
    end,
  },
}
