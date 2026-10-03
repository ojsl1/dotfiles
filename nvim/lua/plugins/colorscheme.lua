-- lua/plugins/colorscheme.lua
-- Justification: for background colorscheme, syntax highlighting etc.
return {
  "luisiacc/gruvbox-baby",
  name = "gruvbox-baby",
  lazy = false,          -- load at startup
  priority = 1000,       -- load before other plugins that depend on colors
  config = function()
    vim.cmd.colorscheme("gruvbox-baby")
  end,
}
