return {
  -- floating window to preview locations
  'rmagatti/goto-preview',
  event = 'VeryLazy',
  opts = {
    default_mappings = true,
    -- resizing_mappings = true,
    references = {
      telescope = require('telescope.themes').get_dropdown({ hide_preview = false }),
    },
  },
}
