return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")

    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
      },
    })

    vim.lsp.set_log_level("debug")

    require("mason-lspconfig").setup_handlers {
      -- The first entry (without a key) will be the default handler
      -- and will be called for each installed server that doesn't have
      -- a dedicated handler.
      function (server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {}
      end,
      ["volar"] = function()
          require("lspconfig").volar.setup({
            -- NOTE: Uncomment to enable volar in file types other than vue.
            -- (Similar to Takeover Mode)

            -- filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },

            -- NOTE: Uncomment to restrict Volar to only Vue/Nuxt projects. This will enable Volar to work alongside other language servers (tsserver).

            -- root_dir = require("lspconfig").util.root_pattern(
            --   "vue.config.js",
            --   "vue.config.ts",
            --   "nuxt.config.js",
            --   "nuxt.config.ts"
            -- ),
            init_options = {
              vue = {
                hybridMode = false,
              },
              -- NOTE: This might not be needed. Uncomment if you encounter issues.

              -- typescript = {
              --   tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
              -- },
            },
          })
        end,

        ["tsserver"] = function()
          local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
          local volar_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"

          require("lspconfig").tsserver.setup({
            -- NOTE: To enable Hybrid Mode, change hybrideMode to true above and uncomment the following filetypes block.
            -- WARN: THIS MAY CAUSE HIGHLIGHTING ISSUES WITHIN THE TEMPLATE SCOPE WHEN TSSERVER ATTACHES TO VUE FILES

            -- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
            init_options = {
              plugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = volar_path,
                  languages = { "vue" },
                },
              },
            },
          })
        end,
    }

    mason_tool_installer.setup({
      ensure_installed = {
        "stylua", -- lua formatter
      },
    })
  end,
}
