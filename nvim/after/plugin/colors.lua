-- after/plugin/colors.lua
-- Store the default background colors
_G.transparency_enabled = _G.transparency_enabled or false
_G.default_hl = _G.default_hl or {}

function ToggleTransparency(color)
  color = color or "gruvbox-baby"
  vim.cmd.colorscheme(color)

  -- On first run after setting colorscheme, cache the original highlights
  if not _G.default_hl.Normal then
    _G.default_hl.Normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
    _G.default_hl.NormalFloat = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
  end

  if _G.transparency_enabled then
    -- Restore the original background colors
    vim.api.nvim_set_hl(0, "Normal", { bg = _G.default_hl.Normal.bg })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = _G.default_hl.NormalFloat.bg })
    print("transparency disabled")
  else
    -- Enable transparency
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    print("transparency enabled")
  end

  -- Toggle the state
  _G.transparency_enabled = not _G.transparency_enabled
end
