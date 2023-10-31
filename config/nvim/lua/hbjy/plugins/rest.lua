local function init()
  require("rest-nvim").setup {
    result_split_horizontal = true,
    encode_url = true,
    highlight = { enabled = true, timeout = 150 },
    result = {
      show_url = true,
      formatters = {
        json = "jq",
        html = function(body)
          return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
        end,
      },
    },
  }
end

return { init = init }
