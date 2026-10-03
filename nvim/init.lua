require("lazy_setup")
-- VIMRC
local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)

vim.api.nvim_create_autocmd(
	"LspAttach",
	{
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(e)
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			local opts = { buffer = e.buf }
			vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts) -- jump to definition
			vim.keymap.set("n", "<leader><space>", vim.lsp.buf.hover, opts) -- hover info
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts) -- broken(?)
			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts) -- jump to type_definition -- after this C-^ to jump back
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- project-wide object rename
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- broken(?)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- list references
			vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts) -- jump to next error
			vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts) -- jump to prev error
			vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts) -- completely autoformats the current buffer
			vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float({ border = "rounded",}) end, opts) -- open current diagnostic in a float

      local client = vim.lsp.get_client_by_id(e.data.client_id)
      vim.notify(("LSP attached: %s"):format(client and client.name or "?"))
		end,
	}
)

-- ~/.local/state/nvim/shada/
-- shada: keep marks/registers across sessions
vim.opt.shada = {"'100", "<500", "s10", "h"}  -- similar to: set shada='100,<100,s10,h

-- viewdir
local viewdir = vim.fn.stdpath('config') .. '/view'
if vim.fn.isdirectory(viewdir) == 0 then
  vim.fn.mkdir(viewdir, "p")
end
vim.o.viewdir = viewdir

-- explicit viewoptions: include folds and cursor
vim.o.viewoptions = "folds,options,slash,unix,cursor"

-- autocmd group to save/load views
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

-- explicit mappings: write and read shada and view
vim.keymap.set('n', '<leader>ss', function()
  vim.cmd('silent! mkview')   -- save current buffer view (folds, options)
  vim.cmd('wshada')           -- then write ShaDa
  vim.notify("Saved ShaDa (marks, registers, command history, jumps, etc) + view (folds, options, cursor, unix, cursor)", vim.log.levels.INFO)
end, { noremap = true, silent = false, desc = 'Save current buffer view and write ShaDa' })

vim.keymap.set('n', '<leader>sl', function()
  vim.cmd('rshada')               -- read/merge shada from disk
  vim.cmd('silent! loadview')     -- load view for current buffer (folds, local window opts)
  local last = vim.fn.line([['"]])
  if last > 0 and last <= vim.fn.line("$") then
    vim.cmd('silent! exe "normal! g`\""') -- jump to last cursor
  end
  vim.notify("Loaded ShaDa (marks, registers, command history, jumps, etc) and view (folds, options, unix, cursor)", vim.log.levels.INFO) -- cant use silent=false with lua callbacks
end, { noremap = true, silent = false, desc = 'Read ShaDa and restore current buffer view & cursor' })

-- Ctrl-Enter and Shift-Enter to enter a plain newline instead of continuing comments
local function plain_newline()
  local fo = vim.bo.formatoptions
  vim.bo.formatoptions = fo:gsub("[ro]", "")
  -- <CR> then in one-shot Normal mode: move to first nonblank, delete to col 0
  local keys = vim.api.nvim_replace_termcodes("<CR><C-o>^<C-o>d0", true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
  vim.defer_fn(function() vim.bo.formatoptions = fo end, 0)
end

vim.keymap.set("i", "<C-CR>", plain_newline, {silent = true})
vim.keymap.set("i", "<S-CR>", plain_newline, {silent = true})

-- 1. Wrap selected lines with /**/
-- ???

-- 2. Prepend // to all selected lines
vim.keymap.set("x", "<leader>c/", [[:s/^/\/\/ /<CR>]], { silent = false })

-- 3. Remove leading // from all selected lines
vim.keymap.set("x", "<leader>cu", [[:s/^\/\/\s\?//<CR>]], { silent = false })

-- Recreate the old :LspInfo command
vim.api.nvim_create_user_command("LspInfo", function()
  vim.print(vim.lsp.get_clients({ bufnr = 0 }))
end, {})
