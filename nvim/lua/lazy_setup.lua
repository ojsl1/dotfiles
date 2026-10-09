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
      { out, "WarningMsg" },
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
vim.opt.relativenumber = true
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>tt", function() ToggleTransparency() end, { desc = "Toggle transparency" })

-----------------------------------------------------------

require("lazy").setup({
  spec = {
    -- STANDALONE PLUGINS under ~/.config/nvim/lua/plugins/
    { import = "plugins" },

    -- LSP, FORMATTER, LINTER, ETC PACKAGE MANAGER --
    -- (nb. doesnt provide lsp configs)
    { "mason-org/mason.nvim", opts = {},
      config = function()
        require("mason").setup()
      end,
    },

    -- MASON EXTENSION: Integrates mason with nvim-Lspconfig.
    -- 1. automatic enablement of LSPs (that're installed via mason)
    -- 2. translates nvim-lspconfig server names to and from mason.nvim pkg names
    -- 3. provides lsp binary paths to nvim-lspconfig
    -- 20261004: removed tag='v1.32.0' and pin=true, might cause issues again
    { "mason-org/mason-lspconfig.nvim",
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
    { "neovim/nvim-lspconfig",
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
          settings = {
            css = {
              lint = {
                validProperties = {},
              },
            },
          },
        })
        vim.lsp.config("lua_ls",{
          -- hack: stop luals nagging when editing nvim configs
          settings = { Lua = { diagnostics = { globals = { "vim" },},},},
        })
        -- OPTIONAL IF USING: mason-lspconfig's automatic_enable.
        vim.lsp.enable({
          -- LSP configuration names
          "clangd",
          "lua_ls",
          "html",
          "cssls",
          "vtsls",
        })
      end,
    },

    -- COMPLETION ENGINE: Display/aggregate completion sources e.g. from LSPs
    { "saghen/blink.cmp",
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
              winblend = 20,
            },
          },
          menu = {
            border = "single",
            winblend = 5,
            draw = {
              columns = {
                { "kind_icon" },
                { "label", "label_description", gap = 1 },
                { "kind" },
              },
            },
          },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer"},
          },
        },
    },
  },
})
