return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    -------------------------------------------------------------------
    -- 1) GLOBAL PICKER DEFAULTS
    -------------------------------------------------------------------
    opts.picker = vim.tbl_deep_extend("force", opts.picker or {}, {
      hidden = true, -- show dotfiles
      ignored = false, -- DO respect .gitignore by default
    })

    -------------------------------------------------------------------
    -- 2) FILE PICKER (space space) behavior
    -- Whitelist .env* files even when ignored
    -------------------------------------------------------------------
    opts.picker.sources = opts.picker.sources or {}
    opts.picker.sources.files = vim.tbl_deep_extend("force", opts.picker.sources.files or {}, {
      hidden = true,
      ignored = false, -- respect gitignore EXCEPT our override

      -- snacks filter: always include `.env` files
      include = {
        "%.env$",
        "%.env%..+$", -- .env.example, .env.local, .env.dev, etc
      },
    })

    -------------------------------------------------------------------
    -- 3) EXPLORER SETTINGS
    -- Also whitelist .env* in explorer
    -------------------------------------------------------------------
    opts.explorer = vim.tbl_deep_extend("force", opts.explorer or {}, {
      hidden = true,
      ignored = false,
      include = {
        "%.env$",
        "%.env%..+$",
      },
    })
  end,
}
