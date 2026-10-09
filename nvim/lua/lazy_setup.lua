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
    { "mason-org/mason-lspconfig.nvim", opts = {},
      dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
      -- OPNTIONAL IF USING: :Mason to install servers.
      ensure_installed = {
        -- Mason pkg names
        "clangd",
        "lua-language-server",
        "html-lsp",
        "css-lsp",
        "vtsls",
      },
      automatic_enable = true,
    },

    -- PROVIDES BASIC LSP CONFIGURATIONS --
    { "neovim/nvim-lspconfig",
      config = function()
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
        keymap = { preset = 'default' },
        -- personal note: I want ctrl-h and ctrl-l for previous and next
        appearance = {
          -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
          -- Adjusts spacing to ensure icons are aligned
          nerd_font_variant = 'mono'
        },
        -- (Default) Only show the documentation popup when manually triggered
        completion = { documentation = { auto_show = true } },
        sources = {
          default = { "lsp", "path", "snippets", "buffer"},
          },
        },
    },
  },
})
