return {
    {

        'neovim/nvim-lspconfig',
        dependencies = {
            -- LSP Support
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            -- LSP completion
            { 'hrsh7th/cmp-nvim-lsp' },
            -- Useful status Update for LSP
            { 'j-hui/fidget.nvim', },
            -- Additional lua configuration for nvim
            { 'folke/neodev.nvim' },
            { 'mrcjkb/rustaceanvim',               version = '^4', ft = { 'rust' }, },
            { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
            -- lsp status line add symbol navigation
            {
                "SmiteshP/nvim-navbuddy",
                dependencies = {
                    "SmiteshP/nvim-navic",
                    "MunifTanjim/nui.nvim"
                },
                opts = { lsp = { auto_attach = true } }
            },
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local path = require("plenary.path")
            local generic_map = function(keys, func, desc, mode)
                if desc then
                    desc = 'LSP: ' .. desc
                end
                vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
            end

            local vmap = function(keys, func, desc)
                generic_map(keys, func, desc, "v")
            end
            local nmap = function(keys, func, desc)
                generic_map(keys, func, desc, "n")
            end

            -- LSP settings.
            --  This function gets run when an LSP connects to a particular buffer.
            local on_attach = function(client, bufnr)
                -- NOTE: Remember that lua is a real programming language, and as such it is possible
                -- to define small helper and utility functions so you don't have to repeat yourself
                -- many times.
                --
                -- In this case, we create a function that lets us more easily define mappings specific
                -- for LSP related items. It sets the mode, buffer and description for us each time.

                vmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
                nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
                nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

                -- See `:help K` for why this keymap
                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

                -- Lesser used LSP functionality
                nmap('gl', vim.diagnostic.open_float, 'Open diagnostic float')
                nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
                nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
                nmap('<leader>wl',
                    function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end,
                    '[W]orkspace [L]ist Folders')
                -- Create a command `:Format` local to the LSP buffer
                vim.api.nvim_buf_create_user_command(bufnr, 'Format',
                    function(_)
                        vim.lsp.buf.format()
                    end,
                    { desc = 'Format current buffer with LSP' })

                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(true)
                end
                if client.server_capabilities.documentSymbolProvider then
                    require("nvim-navic").attach(client, bufnr)
                    require("nvim-navbuddy").attach(client, bufnr)
                end
            end

            require("neodev").setup()

            local lspconfig = require("lspconfig")

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. They will be passed to
            --  the `settings` field of the server config. You must look up that documentation yourself.
            local servers = {
                -- LSP servers
                clangd = {},
                -- gopls = {},
                -- tsserver = {},
                taplo = {
                    -- toml lsp
                    taplo = {},
                },
                ruff = {
                    -- python linter
                    ruff = {},
                },
                -- for numpy completion please install numpydoc
                pylsp = {
                    pylsp = {
                        plugins = {
                            ruff = {
                                enabled = false,
                            },
                            pyflakes = {
                                enabled = false,
                            },
                            yapf = {
                                enabled = false,
                            },
                            autopep8 = {
                                enabled = false,
                            },
                            mccabe = {
                                enabled = false,
                            },
                            pycodestyle = {
                                enabled = false,
                            },
                            pydocstyle = {
                                enabled = false,
                                convention = "google",
                            },
                            -- rope_autoimport = {
                            --     enabled = false,
                            -- },
                            -- rope_completion = {
                            --     enabled = false,
                            --     eager = true
                            -- },
                        }
                    }
                },
                lua_ls = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                        },
                        workspace = {
                            checkThirdParty = false,
                            -- Make the server aware of Neovim runtime files
                            library = {
                                vim.env.VIMRUNTIME,
                                require("neodev.config").types(),
                                "${3rd}/busted/library",
                                "${3rd}/luassert/library",
                            },
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                        -- workspace = { checkThirdParty = false },
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    },
                },
                esbonio = {
                    esbonio = {},
                },
                astro = {
                    astro = {},
                },
                yamlls = {
                    yamlls = {},
                },
                -- gitlab_ci_ls = {
                --     gitlab_ci_ls = {},
                --     },
                -- -- Linter servers
                -- sqlfluff = {},
                -- markdownlint = {},
                -- yamllint = {},
            }

            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.tbl_deep_extend("force",
                vim.lsp.protocol.make_client_capabilities(),
                require('cmp_nvim_lsp').default_capabilities()
           )

            -- Setup mason so it can manage external tooling
            require('mason').setup()

            -- Ensure the servers above are installed
            local mason_lspconfig = require 'mason-lspconfig'

            local mason_auto_installed = vim.tbl_keys(servers)
            table.insert(mason_auto_installed, "omnisharp")
            table.insert(mason_auto_installed, "marksman")

            mason_lspconfig.setup {
                ensure_installed = mason_auto_installed,
                automatic_enable = false
            }

            vim.lsp.config("*", {
                capabilities = capabilities,
                on_attach = on_attach,
            })
            for server_name, _ in pairs(servers) do
                require('lspconfig')[server_name].setup {
                    settings = servers[server_name]
                }
            end
            vim.lsp.config("ty", {
                cmd = { "uvx", 'ty@latest', 'server' },
                filetypes = { 'python' },
                root_markers = { 'ty.toml', 'pyproject.toml', '.git' },
            })
            vim.lsp.enable("ty")

            -- lsp for qt qml using python pyside6
            lspconfig.qmlls.setup {
                cmd = { "qmlls" },
                filetypes = { "qmljs", "qml" },
                capabilities = capabilities,
                on_attach = on_attach,
            }
            vim.lsp.enable("qmlls")
            lspconfig.omnisharp.setup({
                handlers = {
                    ["textDocument/definition"] = function(...)
                        return require("omnisharp_extended").handler(...)
                    end,
                },
                enable_roslyn_analyzers = true,
                organize_imports_on_format = true,
                enable_import_completion = true,
            })
            vim.lsp.enable("omnisharp")

            local extension_path
            local codelldb_path
            local liblldb_path

            if (require("bahugo_conf.utils").is_windows()) then
                extension_path = path:new(os.getenv("LOCALAPPDATA"), "nvim-data", "mason", "packages", "codelldb",
                    "extension")
                codelldb_path = path:new(extension_path, 'adapter', 'codelldb.exe')   -- pour linux sans extension
                liblldb_path = path:new(extension_path, 'lldb', 'lib', 'liblldb.lib') -- pour linux .so
            else
                extension_path = path:new(os.getenv("HOME"), ".local", "share", "nvim", "mason", "packages", "codelldb",
                    "extension")
                codelldb_path = path:new(extension_path, 'adapter', 'codelldb')      -- pour linux sans extension
                liblldb_path = path:new(extension_path, 'lldb', 'lib', 'liblldb.so') -- pour linux .so
            end

            vim.g.rustaceanvim = function()
                local cfg = require('rustaceanvim.config')
                return {
                    -- Plugin configuration
                    tools = {
                        executor = require("rustaceanvim.executors").quickfix
                    },
                    -- LSP configuration
                    server = {
                        on_attach = on_attach,
                        default_settings = {
                            -- rust-analyzer language server configuration
                            ['rust-analyzer'] = {
                            },
                        },
                    },
                    dap = {
                        adapter = cfg.get_codelldb_adapter(codelldb_path.filename, liblldb_path.filename)
                    }
                }
            end
            --
            -- Turn on lsp status information
            require("fidget").setup {
                notification = {
                    window = {
                        winblend = 0
                    },
                }
                -- ... the rest of your fidget config
            }

            require('nvim-lightbulb').setup({ autocmd = { enabled = true } })

            -- Réglage du format d'affichage des diagnostics
            vim.diagnostic.config({
                underline = true,
                -- virtual_lines = true,
                virtual_text = true,
                float = {
                    show_header = true,
                    -- source pour afficher d'où vient le diagnostic
                    source = true,
                    border = 'rounded',
                    focusable = false,
                },
                update_in_insert = false, -- default to false
                severity_sort = false,    -- default to false

                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '✘',
                        [vim.diagnostic.severity.WARN] = '▲',
                        [vim.diagnostic.severity.HINT] = '⚑',
                        [vim.diagnostic.severity.INFO] = '',
                    },
                },
                inlay_hints = {
                    enabled = true,
                    exclude = {}, -- filetypes for which you don't want to enable inlay hints
                },
            })
        end
    },
}
