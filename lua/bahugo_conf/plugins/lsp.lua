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
            { 'mrcjkb/rustaceanvim', version = '^4', ft = { 'rust' },},
            { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
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
                vim.lsp.buf.inlay_hint(bufnr, true)
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
            -- clangd = {},
            -- gopls = {},
            -- tsserver = {},
            ruff_lsp = {
                -- python linter
                ruff_lsp = {},
            },
            pylyzer = {
                -- python static analyzer
                python = {
                    checkOnType = false,
                    diagnostics = false,
                    inlayHints = false,
                    smartCompletion = false
                }
            },
            -- for numpy completion please install numpydoc
            pylsp = {
                pylsp = {
                    plugins = {
                        -- pour ruff voir doc https://github.com/python-lsp/python-lsp-ruff
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
                            ignore = {
                                -- W391 blank line at end of file
                                'W391',
                                -- E402 module level import not at top of file
                                "E402",
                            },
                            maxLineLength = 100
                        },
                        pydocstyle = {
                            enabled = false,
                            convention = "google",
                        },
                        rope_autoimport = {
                            enabled = false,
                        },
                        rope_completion = {
                            enabled = false,
                            eager = true
                        },
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
            astro = {
                astro = {},
            },
            -- -- Linter servers
            -- sqlfluff = {},
            -- markdownlint = {},
            -- yamllint = {},
        }

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        -- Setup mason so it can manage external tooling
        require('mason').setup()

        -- Ensure the servers above are installed
        local mason_lspconfig = require 'mason-lspconfig'

        local mason_auto_installed = vim.tbl_keys(servers)
        table.insert(mason_auto_installed, "omnisharp")
        table.insert(mason_auto_installed, "marksman")

        mason_lspconfig.setup {
            ensure_installed = mason_auto_installed,
            automatic_installation = true
        }

        local warn_if_pylsp_plugins_are_not_installed = function()
            local mypy_exe
            local python_lsp_venv = path:new("mason", "packages", "python-lsp-server", "venv")
            if (require("bahugo_conf.utils").is_windows()) then
                mypy_exe = path:new(os.getenv("LOCALAPPDATA"), "nvim-data", python_lsp_venv, "Scripts", "mypy.exe")
            else
                mypy_exe = path:new(os.getenv("HOME"), ".local", "share", "nvim", python_lsp_venv, "bin", "mypy")
            end
            if not path.exists(mypy_exe) then
                vim.notify(tostring(mypy_exe), vim.log.levels.WARN, {})
                vim.notify(
                    'Pour bénéficier des linters python, il faut installer manuellement les plugins pylsp \n' ..
                    'supplémentaires en tapant la commande suivante: \n' ..
                    ':PylspInstall pylsp-rope pylsp-mypy',

                    vim.log.levels.WARN, {})
            end
        end

        mason_lspconfig.setup_handlers {
            function(server_name)
                local config_handlers = {
                    capabilities = capabilities,
                    on_attach = on_attach,
                    settings = servers[server_name],
                }
                if server_name == "pylsp" then
                    warn_if_pylsp_plugins_are_not_installed()
                end
                -- print("lspconfig setup " .. server_name)
                -- print(vim.inspect(servers[server_name]))
                lspconfig[server_name].setup(config_handlers)
            end,
            ["pylyzer"] = function()
                -- temporary disable pylyzer
                -- lspconfig.pylyzer.setup{
                -- capabilities = capabilities,
                -- on_attach = on_attach,
                -- settings = servers.pylyzer,
                -- }
            end,
            ["omnisharp"] = function()
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
            end,

        }
        -- lsp for qt qml using python pyside6
        lspconfig.qmlls.setup {
            cmd = { "pyside6-qmlls" },
            filetypes = { "qmljs", "qml" },
            capabilities = capabilities,
            on_attach = on_attach
        }
        local rustacean = require("rustaceanvim");

        local on_attach_rust = function(_, bufnr)
            on_attach(_, bufnr)
            -- Hover actions
            nmap("<leader-ha>", rustacean.hover_actions.hover_actions, "Rust hover action")
            -- Code action groups
            nmap("<leader>ca", rustacean.code_action_group.code_action_group, "Rust [C]ode [A]ction")
        end

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
                on_attach = on_attach_rust,
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
            window = {
                blend = 0,
            },
            -- ... the rest of your fidget config
        }

        require('nvim-lightbulb').setup({ autocmd = { enabled = true } })

        -- Réglage du format d'affichage des diagnostics
        vim.diagnostic.config({
            underline = true,
            signs = true,
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
        })

        local sign = function(opts)
            vim.fn.sign_define(opts.name, {
                texthl = opts.name,
                text = opts.text,
                numhl = ''
            })
        end

        sign({ name = 'DiagnosticSignError', text = '✘' })
        sign({ name = 'DiagnosticSignWarn', text = '▲' })
        sign({ name = 'DiagnosticSignHint', text = '⚑' })
        sign({ name = 'DiagnosticSignInfo', text = '' })
    end
    },
}
