return {
  '0xferrous/ansi.nvim',
  config = function()
    require('ansi').setup({
      auto_enable = false,  -- Auto-enable for configured filetypes
      filetypes = { 'log', 'ansi' },  -- Filetypes to auto-enable
      theme = { 'catpuccin' }, -- classic, modern, catpuccin, dracula, onedark, gruvbox, termina
    })
  end
}
