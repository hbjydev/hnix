local function autocmd(args)
    local event = args[1]
    local group = args[2]
    local callback = args[3]

    vim.api.nvim_create_autocmd(event, {
        group = group,
        buffer = args[4],
        callback = function()
            callback()
        end,
        once = args.once,
    })
end

local function init()
    local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>dl", ":Telescope diagnostics bufnr=0<CR>", opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

    require("fidget").setup {}
end

return { init = init }
