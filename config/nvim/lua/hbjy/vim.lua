local function init()
  -- numbering
  vim.opt.nu = true
  vim.opt.relativenumber = true

  -- indentation
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true
  vim.opt.smartindent = true

  -- swap, backup & undo
  vim.opt.swapfile = false
  vim.opt.backup = false
  vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
  vim.opt.undofile = true

  -- searching
  vim.opt.hlsearch = true
  vim.opt.incsearch = true

  -- code folding
  vim.opt.foldcolumn = "1"
  vim.opt.foldlevel = 99
  vim.opt.foldlevelstart = 99
  vim.opt.foldenable = true

  -- other settings
  vim.opt.wrap = false
  vim.opt.termguicolors = true
  vim.opt.scrolloff = 8
  vim.opt.colorcolumn = "80"
  vim.g.netrw_banner = 0
  vim.opt.cursorline = true

  -- disable some providers
  vim.g.loaded_perl_provider = 0
  vim.g.loaded_ruby_provider = 0

  vim.cmd.colorscheme("oxocarbon")

  vim.api.nvim_create_autocmd({"BufNewFile","BufRead"}, {
    pattern = { "*.http" },
    callback = function()
      vim.opt.filetype = "http"
    end
  })
end

return { init = init }
