local function init()
  vim.g.mapleader = " "
  -- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) -- replaced by nvimtree module

  --vim.keymap.set("n", "J", ":m '>+1<CR>gv=gv")
  --vim.keymap.set("n", "K", ":m '<-2<CR>gv=gv")

  vim.keymap.set("n", "Y", "yg$")
  vim.keymap.set("n", "J", "mzJ`z")
  vim.keymap.set("n", "<C-d>", "<C-d>zz")
  vim.keymap.set("n", "<C-u>", "<C-u>zz")
  vim.keymap.set("n", "n", "nzzzv")
  vim.keymap.set("n", "N", "Nzzzv")

  vim.keymap.set("n", "<leader>b]", "<cmd>bn<cr>")
  vim.keymap.set("n", "<leader>b[", "<cmd>bp<cr>")
  vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>")

  vim.keymap.set("x", "<leader>p", [["_dP]])

  vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
  vim.keymap.set("n", "<leader>Y", [["+Y]])

  vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

  vim.keymap.set("i", "<C-c>", "<Esc>")

  vim.keymap.set("n", "Q", "<nop>")

  vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
  vim.keymap.set("n", "<C-j>", "<cmd>cprevCR>zz")
  vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")
  vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")

  vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
  vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

  vim.keymap.set("n", "<C-PageDown>", ":bn<CR>", { silent = true })
  vim.keymap.set("n", "<C-PageUp>", ":bp<CR>", { silent = true })

  vim.keymap.set("n", "<leader>pv", ":Neotree toggle<CR>")

  vim.keymap.set("n", "<leader><space>", ":Telescope buffers<CR>")
  vim.keymap.set("n", "<leader>pf", ":Telescope find_files<CR>")
  vim.keymap.set("n", "<C-p>", ":Telescope git_files<CR>")
  vim.keymap.set("n", "<leader>ps", function()
    require('telescope.builtin').grep_string({
      search = vim.fn.input { prompt = "Grep > " },
    })
  end)
end

return { init = init }
