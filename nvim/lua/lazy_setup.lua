-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

------------------------------------------------------------

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-----------------------------------------------------------

require("lazy").setup({
  spec = {
    -- STANDALONE PLUGINS under ~/.config/nvim/lua/plugins/
    { import = "plugins" },

    -- LSP, FORMATTER, LINTER, ETC PACKAGE MANAGER --
    -- (nb. doesnt provide lsp configs)
    {
      "mason-org/mason.nvim",
      opts = {},
      config = function()
        require("mason").setup()
      end,
    },

    -- MASON EXTENSION: Integrates mason with nvim-Lspconfig.
    -- 1. automatic enablement of LSPs (that're installed via mason)
    -- 2. translates nvim-lspconfig server names to and from mason.nvim pkg names
    -- 3. provides lsp binary paths to nvim-lspconfig
    -- 20261004: removed tag='v1.32.0' and pin=true, might cause issues again
    {
      "mason-org/mason-lspconfig.nvim",
      dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
      opts = {
        ensure_installed = {
          -- LSP configuration names
          "clangd",
          "lua_ls",
          -- "html" (use below patched LSP for combined html/css/js intellisense)
          "cssls",
          "vtsls",
        },
        automatic_enable = true,
      },
    },

    -- PROVIDES BASIC LSP CONFIGURATIONS --
    {
      "neovim/nvim-lspconfig",
      config = function()
        -- Use a patched HTML language server from NPM
        vim.lsp.config("html", {
          cmd = {
            "npx",
            "--yes",
            -- "--no-update-notifier",
            -- "--loglevel=error", if lsp.log starts growing too fast
            "--package=@t1ckbase/vscode-langservers-extracted",
            "vscode-html-language-server",
            "--stdio",
          },
        })
        vim.lsp.config("*", {
          capabilities = require("blink.cmp").get_lsp_capabilities(),
        })
        vim.lsp.config("html", {
          settings = { css = { lint = { validProperties = {}, }, }, },
        })
        vim.lsp.config("lua_ls", {
          -- hack: stop luals nagging when editing nvim configs
          settings = { Lua = { diagnostics = { globals = { "vim" }, }, }, },
        })
        -- OPTIONAL IF USING: mason-lspconfig's automatic_enable.
        vim.lsp.enable({
          -- LSP configuration names
          "clangd", "lua_ls", "html", "cssls", "vtsls",
        })
      end,
    },
    -- COMPLETION ENGINE: Display/aggregate completion sources e.g. from LSPs
    {
      "saghen/blink.cmp",
      dependencies = { 'rafamadriz/friendly-snippets' },
      version = "1.*",
      --@module 'blink.cmp'
      --@type 'blink.cmp.Config'
      opts = {
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = {
          preset = 'default',
          ["<C-d>"] = { "scroll_documentation_down", "fallback" },
          ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        },
        signature = {
          -- not supported by all LSPs
          enabled = true, -- default off
          window = {
            border = "rounded",
          },
        },
        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
        },
        completion = {
          documentation = {
            auto_show = true, -- default off
            window = {
              border = "single",
              winblend = 0, -- using this breaks shift-primal/blink-icon-preview
            },
          },
          menu = {
            border = "single",
            winblend = 5,
            draw = {
              columns = {
                { "kind_icon" },
                { "label",    "label_description", gap = 1 },
                { "kind" },
              },
            },
          },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
      },
    },
    -- Inline icon previews in Blink documentation floats
    {
      "shift-primal/blink-icon-preview.nvim",
      dependencies = { "folke/snacks.nvim", "saghen/blink.cmp" },
      init = function()
        require("blink-icon-preview").setup({
          filetype = "blink-cmp-documentation",
          wo = { wrap = false, conceallevel = 2 },
          image_pattern = "data:image/",
          kitty_override = true,
        })
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      lazy = false,
      -- requires "tree-sitter-cli" package and manually:
      -- :Lazy sync
      -- :TSInstall tsx javascript typescript css html
    },
    -- FILE EXPLORER: with previews etc
    {
      "nvim-neo-tree/neo-tree.nvim",
      -- TOFIX: move opts.window.mappings and keys to init.lua
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- optional, not required
        "folke/snacks.nvim", -- for use_snacks_image
      },
      lazy = false,
      -- LazyVim defaults:
      -- keys = {
      --   {
      --     "<leader>fe",
      --     function()
      --       require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
      --     end,
      --     desc = "Explorer NeoTree (Root Dir)",
      --   },
      --   {
      --     "<leader>fE",
      --     function()
      --       require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
      --     end,
      --     desc = "Explorer NeoTree (cwd)",
      --   },
      --   { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
      --   { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)",      remap = true },
      --   {
      --     "<leader>ge",
      --     function()
      --       require("neo-tree.command").execute({ source = "git_status", toggle = true })
      --     end,
      --     desc = "Git Explorer",
      --   },
      --   {
      --     "<leader>be",
      --     function()
      --       require("neo-tree.command").execute({ source = "buffers", toggle = true })
      --     end,
      --     desc = "Buffer Explorer",
      --   },
      -- },
      opts = {
        -- LazyVim defaults:
        -- sources = { "filesystem", "buffers", "git_status" },
        -- open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
        -- filesystem = {
        --   bind_to_cwd = false,
        --   follow_current_file = { enabled = true },
        --   use_libuv_file_watcher = true,
        -- },
        window = {
          mappings = {

            ["l"] = "open",
            ["h"] = "close_node",
            ["<space>"] = "none",
            ["P"] = {
              "toggle_preview",
              config = {
                use_float = true,
                use_snacks_image = true,
                use_image_nvim = false
              }
            },
            ["Y"] = {
              function(state)
                local node = state.tree:get_node()
                local path = node:get_id()
                vim.fn.setreg("+", path, "c")
              end,
              desc = "Copy path to clipboard",
            },
            ["O"] = {
              function(state)
                require("lazy.util").open(state.tree:get_node().path, { system = true })
              end,
              desc = "Open with System Application",
            },
          },
        },
      },
    },
    -- NEOTREE INTEGRATIONS 1:
    -- { "Crysthamus/nvim-file-operations",
    --   dependencies = {
    --     "nvim-neo-tree/neo-tree.nvim", -- makes sure that this loads after Neo-tree.
    --   },
    --   config = function()
    --     require("nvim-file-operations").setup()
    --   end,
    -- },
    -- NEOTREE INTEGRATION 2:
    -- { "s1n7ax/nvim-window-picker",
    --   version = "2.*",
    --   config = function()
    --     require("window-picker").setup({
    --       filter_rules = {
    --         include_current_win = false,
    --         autoselect_one = true,
    --         -- filter using buffer options
    --         bo = {
    --           -- if the file type is one of following, the window will be ignored
    --           filetype = { "neo-tree", "neo-tree-popup", "notify" },
    --           -- if the buffer type is one of following, the window will be ignored
    --           buftype = { "terminal", "quickfix" },
    --         },
    --       },
    --     })
    --   end,
    -- },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
        bigfile = { enabled = false },
        dashboard = { enabled = false },
        explorer = { enabled = false },
        indent = { enabled = true },
        input = { enabled = false },
        picker = { enabled = false },
        notifier = { enabled = true },
        quickfile = { enabled = false },
        scope = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },
        words = { enabled = false },
        image = {
          enabled = true,
          formats = {
            "png", "jpg", "jpeg", "gif", "bmp", "webp", "tiff", "heic",
            "avif", "mp4", "mov", "avi", "mkv", "webm", "pdf", "icns", "svg",
          },
          doc = { enabled = true, inline = true, float = true },
          convert = {
            notify = true,
            magick = {
              default = { "{src}[0]", "-scale", "1920x1080>" },
              vector = { "-density", "192", "-background", "none", "{src}[{page}]", "-resize", "256x256" },
              math = { "-density", 192, "{src}[{page}]", "-trim" },
              pdf = {
                "-density", 192, "{src}[{page}]",
                "-background", "white", "-alpha", "remove", "-trim",
              },
            },
          },
        },
      },
    },
  },
})
