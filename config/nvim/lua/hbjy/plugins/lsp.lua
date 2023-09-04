local fidget = require 'fidget'
local rust_tools = require 'rust-tools'
local lspconfig = require 'lspconfig'
local treesitter = require 'nvim-treesitter.configs'
local treesitter_context = require 'treesitter-context'

local function on_attach(_, buffer)
  vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local bufopts = { noremap = true, silent = true, buffer = buffer }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>F", vim.lsp.buf.format, bufopts)

  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, bufopts)

  vim.keymap.set("n", "<leader>ds", ":Telescope lsp_document_symbols<CR>", bufopts)
  vim.keymap.set("n", "<leader>rr", ":Telescope lsp_references<CR>", bufopts)
end

local function init()
  rust_tools.setup {
    server = {
      on_attach = on_attach,
    },
  }

  local language_servers = {
    bashls = {},
    cssls = {},
    diagnosticls = {
      filetypes = { "python" },
      init_options = {
        filetypes = {
          python = "black",
        },
        formatFiletypes = {
          python = "black",
        },
        formatters = {
          black = {
            command = "black",
            args = { "--quiet", "-" },
            rootPatterns = { "pyproject.toml", "requirements.in", "requirements.txt" },
          },
        },
      },
    },
    dockerls = {},
    gopls = {
      settings = {
        gopls = {
          gofumpt = true,
        },
      },
    },
    html = {},
    jsonls = {},
    jsonnet_ls = {},
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
          runtime = { version = 'LuaJIT' },
          telemetry = { enable = false },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    },
    nil_ls = {
      settings = {
        ["nil"] = {
          formatting = { command = { "nixpkgs-fmt" } },
        },
      },
    },
    pylsp = {
      settings = {
        pylsp = {
          plugins = {
            flake8 = { enabled = true },
            pycodestyle = { enabled = false },

            pylsp_mypy = { report_progress = true },
            black = { enabled = true },
          },
        },
      },
    },
    -- pyright = {
    --   settings = {
    --     python = {
    --       analysis = {
    --         autoSearchPaths = true,
    --         diagnosticMode = "workspace",
    --         useLibraryCodeForTypes = true,
    --       },
    --     },
    --   },
    -- },
    terraformls = {},
    tsserver = {},
    yamlls = {
      settings = {
        yaml = {
          keyOrdering = false,
        },
      },
    },
  }

  for server, server_config in pairs(language_servers) do
    local config = { on_attach = on_attach }

    if server_config then
      for k, v in pairs(server_config) do
        config[k] = v
      end
    end

    lspconfig[server].setup(config)
  end

  local opts = { noremap = true, silent = true }
  vim.keymap.set("n", "<leader>do", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<leader>dl", ":Telescope diagnostics bufnr=0<CR>", opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

  treesitter.setup {
    highlight = { enable = true },
    indent = { enable = true },
    rainbow = { enable = true },
  }

  treesitter_context.setup {}

  fidget.setup {}
end

return { init = init }
