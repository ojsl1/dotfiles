require("lazy_setup")
local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)

-- =========================================================
-- LSP related
-- =========================================================
do
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(e)
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local function map(mode, keys, action, description)
        vim.keymap.set(mode, keys, action, { buffer = e.buf, desc = description, })
      end
      map("n", "gd", vim.lsp.buf.definition, "Jump to definition")
      map("n", "<leader><space>", vim.lsp.buf.hover, "Show hover documentation")
      map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
      map("n", "<leader>D", vim.lsp.buf.type_definition, "Jump to type definition, C-^ to jump back")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Project-wide rename symbol")
      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code actions") -- depends on current lsp's capabilities & code context
      map("n", "gr", vim.lsp.buf.references, "List references")
      map("n", "]d", vim.diagnostic.goto_next, "Jump to next error")
      map("n", "[d", vim.diagnostic.goto_prev, "Jump to prev error")
      map("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, "Completely autoformat the current buffer")
      map("n", "<leader>d", function()
        vim.diagnostic.open_float({ border = "rounded" })
      end, "Open current diagnostic in a float")

      local client = vim.lsp.get_client_by_id(e.data.client_id)
      vim.notify(("LSP attached: %s"):format(client and client.name or "?"))
    end,
    })

  -- Alternatively :checkhealth vim.lsp
  vim.api.nvim_create_user_command("LspInfo", function()
    vim.print(vim.lsp.get_clients({ bufnr = 0 }))
  end, {
    desc = "Recreate the old :LspInfo command",
  })
end

-- =========================================================
-- Options: Persistence
-- =========================================================
do
  -- ~/.local/state/nvim/shada/
  -- Preserve marks, registers, history, etc. across sessions
  vim.opt.shada = {"'100", "<500", "s10", "h"}  -- similar to: set shada='100,<100,s10,h

  -- Store window views under neovim configuration dir
  local viewdir = vim.fn.stdpath('config') .. '/view'

  if vim.fn.isdirectory(viewdir) == 0 then
    vim.fn.mkdir(viewdir, "p")
  end
  vim.o.viewdir = viewdir

  -- explicit viewoptions: include folds, cursor
  vim.o.viewoptions = "folds,slash,unix,cursor"
end

-- =========================================================
-- Autocommands: Persistence
-- =========================================================
do
  vim.api.nvim_create_augroup("AutoSaveViews", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    group = "AutoSaveViews",
    pattern = "*",
    callback = function() vim.cmd("silent! mkview") end,
  })
  vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    group = "AutoSaveViews",
    pattern = "*",
    callback = function() vim.cmd("silent! loadview") end,
  })
  -- restore last cursor position
  vim.api.nvim_create_augroup("RestoreCursor", { clear = true })
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = "RestoreCursor",
    pattern = "*",
    callback = function()
      local last = vim.fn.line([['"]])
      if last > 0 and last <= vim.fn.line("$") then
        vim.cmd([[silent! exe "normal! g`\""]])
      end
    end,
  })
end

-- =========================================================
-- Keymaps: Persistence
-- =========================================================
do
  -- force write both shada and view files
  vim.keymap.set('n', '<leader>ss', function()
    vim.cmd('silent! mkview')   -- save current buffer view (folds, cursor)
    vim.cmd('wshada')           -- then write ShaDa
    vim.notify("Saved ShaDa (marks, registers, command history, jumps, etc) + view (folds, cursor, unix, cursor)", vim.log.levels.INFO)
  end, {noremap = true, desc = 'Save current buffer view and write ShaDa'}
  )

  -- force load both shada and view files
  vim.keymap.set('n', '<leader>sl', function()
    vim.cmd('rshada')               -- read/merge shada from disk
    vim.cmd('silent! loadview')     -- load view for current buffer (folds, cursor)

    local last = vim.fn.line([['"]])
    if last > 0 and last <= vim.fn.line("$") then
      vim.cmd('silent! exe "normal! g`\""') -- jump to last cursor
    end

    vim.notify("Loaded ShaDa (marks, registers, command history, jumps, etc) and view (folds, unix, cursor)", vim.log.levels.INFO) -- cant use silent=false with lua callbacks
  end, {noremap = true, desc = 'Read ShaDa and restore current buffer view & cursor'}
  )

  -- delete view files
  vim.keymap.set("n", "<leader>sv", function()
    local viewdir = vim.o.viewdir
    local views = vim.fn.glob(viewdir .. "/**/*", false, true)
    local files = {}

    for _, path in ipairs(views) do
      if vim.fn.filereadable(path) == 1 then
        table.insert(files, path)
      end
    end

    local count = #files
    if count == 0 then
      vim.notify("No saved view files found.", vim.log.levels.INFO)
      return
    end

    local choice = vim.fn.confirm(
      ("Remove all %d saved view file(s)?"):format(count), "&Yes\n&No", 2
    )

    if choice ~= 1 then
      vim.notify("View cleanup cancelled.", vim.log.levels.INFO)
      return
    end

    local removed = 0
    for _, path in ipairs(files) do
      if vim.fn.delete(path) == 0 then
        removed = removed + 1
      end
    end

    vim.notify(("Removed %d of %d saved view file(s)."):format(removed, count),
      vim.log.levels.INFO
    )
  end, {noremap = true, desc = "Delete all saved views"}
  )

  -- delete shada file
  vim.keymap.set("n", "<leader>sd", function()
    local shadafile = vim.o.shadafile

    if shadafile == "" then
      shadafile = vim.fn.stdpath("state") .. "/shada/main.shada"
    end

    if shadafile == "NONE" then
      vim.notify("ShaDa persistence is disabled.", vim.log.levels.WARN)
      return
    end

    shadafile = vim.fn.expand(shadafile)

    local size = vim.fn.getfsize(shadafile)
    if size < 0 then
      vim.notify("No ShaDa file found: " .. shadafile, vim.log.levels.INFO)
      return
    end

    local size_kib = size / 1024

    local choice = vim.fn.confirm(
      ("Delete the ShaDa file (%d bytes / %.2f KiB)?\n%s")
      :format(size, size_kib, shadafile),
      "&Yes\n&No", 2
    )

    if choice ~= 1 then
      vim.notify("ShaDa deletion cancelled.", vim.log.levels.INFO)
      return
    end

    if vim.fn.delete(shadafile) == 0 then
      vim.notify(
        ("Deleted ShaDa file (%d bytes / %.2f KiB)."):format(size, size_kib),
        vim.log.levels.INFO
      )
    else
      vim.notify("Failed to delete ShaDa file.", vim.log.levels.ERROR)
    end
  end, {noremap = true, desc = "Delete ShaDa file"}
  )
end

-- =========================================================
-- Keymaps: Editing
-- =========================================================
do
  -- Insert a newline without continuing comments
  local function plain_newline()
    local fo = vim.bo.formatoptions
    vim.bo.formatoptions = fo:gsub("[ro]", "")
    -- <CR> then in one-shot Normal mode: move to first nonblank, delete to col 0
    local keys = vim.api.nvim_replace_termcodes("<CR><C-o>^<C-o>d0", true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
    vim.defer_fn(function() vim.bo.formatoptions = fo end, 0)
  end

  vim.keymap.set("i", "<C-CR>", plain_newline, {
    desc = "Insert plain newline",
  })
  vim.keymap.set("i", "<S-CR>", plain_newline, {
    desc = "Insert plain newline",
  })

  vim.keymap.set("x", "<leader>c/", [[:s/^/\/\/ /<CR>]], {
    desc = "Prepend // to all selected lines",
  })

  vim.keymap.set("x", "<leader>cu", [[:s/^\/\/\s\?//<CR>]], {
    desc = "Remove leading // from all selected lines",
  })

  vim.keymap.set("x", "<leader>c*", function()
      local start_line = vim.fn.line("v")
      local end_line = vim.fn.line(".")

      if start_line > end_line then
          start_line, end_line = end_line, start_line
      end

      vim.fn.append(end_line, "*/")
      vim.fn.append(start_line - 1, "/*")
  end, {
      desc = "Wrap selected lines in /* */",
  })
end

-- =========================================================
-- Keymaps: Navigation and External Tools
-- =========================================================
do
  vim.keymap.set("n", "<leader>b", function()
    vim.fn.jobstart({"firefox", vim.fn.expand("%:p")}, {
      detach = true,
    })
  end, {
    desc = "Open current file in Firefox, e.g. HTML files",
  })
end

-- =========================================================
-- Options and Keymaps: Folds
-- =========================================================
do
  vim.opt.foldmethod = "indent"
  vim.opt.foldnestmax = 3
  vim.opt.foldlevel = 0
  vim.opt.foldenable = true

  vim.keymap.set("i", "<F9>", "<C-O>za", { desc = "Toggle fold" })
  vim.keymap.set("n", "<F9>", "za", { desc = "Toggle fold" })
  vim.keymap.set("o", "<F9>", "<C-C>za", { desc = "Toggle fold" })

  vim.keymap.set("x", "<F9>", "zf", { desc = "Create fold from selection" })
end

-- =========================================================
-- Keymaps: Plugins
-- =========================================================
do
  vim.keymap.set("n", "<space>fw", ":Telescope file_browser<CR>", {
    desc = "Telescope file browser: open in current working directory",
  })

  vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", {
    desc = "Telescope file browser: open in current buffers directory",
  })

  local telescope = (require "telescope")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local fb = require ("telescope._extensions.file_browser.actions")

  -- Opens all tagged files in separate tabs/buffers.
  local function open_multi_selection(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local selections = picker:get_multi_selection()

    -- (If nothing is tagged open the current file normally)
    if #selections == 0 then
      actions.select_default(prompt_bufnr)
      return
    end

    actions.close(prompt_bufnr)

    for _, entry in ipairs(selections) do
      local path = entry.path or entry.filename or entry.value
      if path then
        -- (change as needed tabedit/edit = tabs/buffers)
        vim.cmd("tabedit " .. vim.fn.fnameescape(path))
      end
    end
  end

  telescope.setup({
    extensions = {
      file_browser = {
        mappings = {
          i = {
            ["<C-CR>"] = open_multi_selection,
            -- to see loaded keymaps: <C-7> or ? in insert/normal mode respectively
            -- defaults listed below
            ["<A-c>"] = fb.create,
            ["<S-CR>"] = fb.create_from_prompt,
            ["<A-r>"] = fb.rename,
            ["<A-m>"] = fb.move,
            ["<A-y>"] = fb.copy,
            ["<A-d>"] = fb.remove,
            ["<C-o>"] = fb.open,
            ["<C-g>"] = fb.goto_parent_dir,
            ["<C-e>"] = fb.goto_home_dir,
            ["<C-w>"] = fb.goto_cwd,
            ["<C-t>"] = fb.change_cwd,
            ["<C-f>"] = fb.toggle_browser,
            ["<C-h>"] = fb.toggle_hidden,
            ["<C-s>"] = fb.toggle_all,
            ["<bs>"] = fb.backspace,
          },
          n = {
            ["<C-CR>"] = open_multi_selection,
            -- to see loaded keymaps: <C-7> or ? in insert/normal mode respectively
            -- defaults listed below
            ["c"] = fb.create,
            ["r"] = fb.rename,
            ["m"] = fb.move,
            ["y"] = fb.copy,
            ["d"] = fb.remove,
            ["o"] = fb.open,
            ["g"] = fb.goto_parent_dir,
            ["e"] = fb.goto_home_dir,
            ["w"] = fb.goto_cwd,
            ["t"] = fb.change_cwd,
            ["f"] = fb.toggle_browser,
            ["h"] = fb.toggle_hidden,
            ["s"] = fb.toggle_all,
          },
        },
      },
    },
  })

  telescope.load_extension("file_browser")
end
