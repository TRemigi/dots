return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "Bilal2453/luvit-meta", lazy = true },
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },
			-- Autoformatting
			"stevearc/conform.nvim",
		},
		config = function()
			-- Formatters
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					sh = { "beautysh" },
					lua = { "stylua" },
					javascript = { "prettierd" },
					typescript = { "prettierd", lsp_format = "never" },
					css = { "prettierd" },
					html = { "prettierd" },
					json = { "prettierd" },
					yaml = { "prettierd" },
					markdown = { "prettierd" },
					xml = { "prettierd" },
				},
			})

			local lspconfig = require("lspconfig")
			local servers = {
				bashls = true,
				gopls = {
					manual_install = true,
					settings = {
						gopls = {
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
						},
					},
				},
				denols = {
					root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
					settings = {
						deno = {
							enable = true,
							suggest = {
								imports = {
									hosts = {
										["https://deno.land"] = true,
										["file://"] = true,
									},
								},
							},
						},
					},
				},
				laravel_ls = {
					root_dir = require("lspconfig.util").root_pattern("artisan", "composer.json", ".git"),
					manual_install = true,
				},
				lua_ls = {
					server_capabilities = {
						semanticTokensProvider = vim.NIL,
					},
				},
				intelephense = vim.fn.filereadable("artisan") == 1 and false or {
					root_dir = require("lspconfig.util").root_pattern("composer.json", ".git"),
					settings = {
						intelephense = {
							files = {
								maxSize = 1000000,
								exclude = {
									"**/node_modules/**",
									"**/.git/**",
									"**/storage/**",
									"**/coverage/**",
									"**/tests/_support/_generated/**",
								},
							},
						},
					},
				},
				phpactor = {
					root_dir = lspconfig.util.root_pattern("composer.json", ".git"),
					server_capabilities = {
						completionProvider = false,
						hoverProvider = false,
						definitionProvider = false,
						typeDefinitionProvider = false,
						implementationProvider = false,
						referencesProvider = false,
						renameProvider = false,
						documentSymbolProvider = false,
						workspaceSymbolProvider = false,
						documentFormattingProvider = false,
						documentRangeFormattingProvider = false,
						codeLensProvider = false,
						documentHighlightProvider = false,
						signatureHelpProvider = false,
						semanticTokensProvider = vim.NIL,
					},
				},
				pyright = true,
				ts_ls = {
					filetypes = {
						"typescript",
						"javascript",
						"typescriptreact",
						"javascriptreact",
					},
					init_options = {},
					server_capabilities = {
						documentFormattingProvider = false,
					},
				},
				jsonls = {
					server_capabilities = {
						documentFormattingProvider = false,
					},
					settings = {
						json = {
							validate = { enable = true },
						},
					},
				},
				vuels = { filetypes = { "vue" } },
				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								enable = false,
								url = "",
							},
						},
					},
				},
			}

			local servers_to_install = vim.tbl_filter(function(key)
				local t = servers[key]

				if type(t) == "table" then
					return not t.manual_install
				else
					return t
				end
			end, vim.tbl_keys(servers))

			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			vim.lsp.set_log_level("ERROR")

			local ensure_installed = {
				"gopls",
				"lua_ls",
				"stylua",
				"ts_ls",
				"vue-language-server",
				-- "laravel_ls", add this back in when Mason is updated to include it
			}

			vim.list_extend(ensure_installed, servers_to_install)

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lspconfig = lspconfig
			for name, opts in pairs(servers) do
				if opts ~= true and opts ~= false then
					lspconfig[name].setup(vim.tbl_deep_extend("force", {
						capabilities = capabilities,
					}, opts))
				elseif opts == true then
					lspconfig[name].setup({ capabilities = capabilities })
				end
			end

			local disable_semantic_tokens = {
				lua = true,
			}

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
					for type, icon in pairs(signs) do
						local hl = "DiagnosticSign" .. type
						vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
					end

					-- set keybinds
					local opts = { buffer = args.buf, silent = true }
					local keymap = vim.keymap

					opts.desc = "Show LSP references"
					keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

					opts.desc = "Go to declaration"
					keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

					opts.desc = "Show LSP definitions"
					keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

					opts.desc = "Show LSP implementations"
					keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

					opts.desc = "Show LSP type definitions"
					keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

					opts.desc = "See available code actions"
					keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

					opts.desc = "Smart rename"
					keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

					opts.desc = "Show buffer diagnostics"
					keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

					opts.desc = "Show line diagnostics"
					keymap.set("n", "<leader>sd", vim.diagnostic.open_float, opts) -- show diagnostics for line

					opts.desc = "Go to previous diagnostic"
					keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

					opts.desc = "Go to next diagnostic"
					keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

					opts.desc = "Show documentation for what is under cursor"
					keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

					opts.desc = "Restart LSP"
					keymap.set("n", "<leader>rl", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

					vim.keymap.set({ "n", "v" }, "<leader>mp", function()
						conform.format({
							lsp_fallback = true,
							async = false,
							timeout_ms = 500,
						})
					end, { desc = "Conform format" })

					local bufnr = args.buf
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

					local settings = servers[client.name]
					if type(settings) ~= "table" then
						settings = {}
					end

					vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

					local filetype = vim.bo[bufnr].filetype
					if disable_semantic_tokens[filetype] then
						client.server_capabilities.semanticTokensProvider = nil
					end

					-- Override server capabilities
					if settings.server_capabilities then
						for k, v in pairs(settings.server_capabilities) do
							if v == vim.NIL then
								---@diagnostic disable-next-line: cast-local-type
								v = nil
							end

							client.server_capabilities[k] = v
						end
					end
				end,
			})

			require("lsp_lines").setup()
			vim.diagnostic.config({ virtual_text = false, virtual_lines = false })

			vim.keymap.set("", "<leader>l", function()
				local config = vim.diagnostic.config() or {}
				if config.virtual_text then
					vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
				elseif config.virtual_lines then
					vim.diagnostic.config({ virtual_text = false, virtual_lines = false })
				else
					vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
				end
			end, { desc = "Toggle lsp_lines" })
		end,
	},
}
