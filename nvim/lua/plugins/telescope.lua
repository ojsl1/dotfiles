-- lua/plugins/telescope.lua
-- Reason for installing: Powerful search engine
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    { "<leader>pf", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    { "<C-p>",      function() require("telescope.builtin").git_files()  end, desc = "Git files: C-n/C-p navigates, C-d/C-u scrolls"  },
    { "<leader>ps", function() local input = vim.fn.input("Grep > ") if input ~= "" then require("telescope.builtin").grep_string({ search = input }) end
    end, desc = "Project search" },
  },
  opts = {}, -- keep for future Telescope opts if needed
}
