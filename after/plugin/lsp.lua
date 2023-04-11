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
local on_attach = function(_, bufnr)
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
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')
    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
    -- LSP servers
    -- clangd = {},
    -- gopls = {},
    rust_analyzer = {},
    -- tsserver = {},
    pylsp = {
        pylsp = {
            plugins = {
                -- pour ruff voir doc https://github.com/python-lsp/python-lsp-ruff
                ruff = {
                    enabled = true,
                    lineLength = 100,
                    ignore = {
                        -- E402 module level import not at top of file
                        "E402",
                    },

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
    marksman = {},
    omnisharp = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
                globals = { 'vim' }
            }
        },
    },
    -- -- Linter servers
    -- sqlfluff = {},
    -- markdownlint = {},
    -- yamllint = {},
    -- -- DAP servers
    -- debugpy = {},
}

require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'


mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = true
}

local warn_if_pylsp_plugins_are_not_installed = function()
    local ruff_exe
    local python_lsp_venv = path:new("mason", "packages", "python-lsp-server", "venv")
    if (require("bahugo_conf.utils").is_windows())

    then
        ruff_exe = path:new(os.getenv("LOCALAPPDATA"), "nvim-data", python_lsp_venv, "Scripts", "ruff.exe")
    else
        ruff_exe = path:new(os.getenv("HOME"), ".local", "share", "nvim", python_lsp_venv, "bin", "ruff")
    end
    if not path.exists(ruff_exe) then
        vim.notify(tostring(ruff_exe), vim.log.levels.WARN, {})
        vim.notify(
            'Pour bénéficier des linters python, il faut installer manuellement les plugins pylsp \n' ..
            'supplémentaires en tapant la commande suivante: \n' ..
            ':PylspInstall python-lsp-ruff pylsp-rope pylsp-mypy',

            vim.log.levels.WARN, {})
    end
end


mason_lspconfig.setup_handlers {
    function(server_name)
        if server_name == "pylsp" then
            warn_if_pylsp_plugins_are_not_installed()
        end
        -- print("lspconfig setup " .. server_name)
        -- print(vim.inspect(servers[server_name]))
        require('lspconfig')[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
        }
    end,
}

local rt = require("rust-tools")
local on_attach_rust = function(_, bufnr)
    on_attach(_, bufnr)
    -- Hover actions
    nmap("<C-space>", rt.hover_actions.hover_actions, "Rust hover action" )
    -- Code action groups
    nmap("<Leader>ca", rt.code_action_group.code_action_group, "Rust [C]ode [A]ction")

end

rt.setup({
    server = {
        on_attach = on_attach_rust
    },
})

-- Turn on lsp status information
require("fidget").setup {
    window = {
        blend = 0,
    },
    -- ... the rest of your fidget config
}

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
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
    severity_sort = false, -- default to false
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
