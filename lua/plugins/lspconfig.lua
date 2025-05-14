return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'hrsh7th/cmp-nvim-lsp',
    { 'j-hui/fidget.nvim', opts = {} },
    { 'Hoffs/omnisharp-extended-lsp.nvim', opts = {}, config = function() end },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-T>.
        map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

        -- Fuzzy find all the symbols in your current workspace
        --  Similar to document symbols, except searches over your whole project.
        map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end

        if client and client.name == 'eslint' then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = event.buf,
            command = 'EslintFixAll',
          })
        end

        if client and client.name == 'omnisharp' then
          map('grd', require('omnisharp_extended').telescope_lsp_definition, 'Omnisharp: [G]oto [D]efinition')
          map('grr', require('omnisharp_extended').telescope_lsp_references, 'Omnisharp: [G]oto [R]eferences')
          map('gri', require('omnisharp_extended').telescope_lsp_implementation, 'Omnisharp: [G]oto [I]mplementation')
          map('grt', require('omnisharp_extended').telescope_lsp_type_definition, 'Omnisharp: Type [D]efinition')
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP Specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - on_init
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      bashls = {
        filetypes = { 'sh', 'bats', 'bash' },
      },
      eslint = {
        on_init = function(client)
          client.config.settings.workingDirectory = { directory = client.config.root_dir }
        end,
        settings = {
          -- workingDirectories = { mode = 'auto' }, -- should work but isn't doing anything
        },
      },
      gopls = {},
      jsonls = {},
      lua_ls = {
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
              },
              checkThirdParty = false,
              -- Tells lua_ls where to find all the Lua files that you have loaded
              -- for your neovim configuration.
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
              -- If lua_ls is really slow on your computer, you can try this instead:
              -- library = { vim.env.VIMRUNTIME },
            },
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      marksman = {},
      -- omnisharp = {},
      pyright = {},
      rust_analyzer = {},
      taplo = {
        root_markers = { '.taplo.toml' },
      },
      terraformls = {},
      ts_ls = {
        on_init = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
      },
      yamlls = {
        on_init = function(client)
          client.server_capabilities.documentFormattingProvider = true
        end,
        filetypes = { 'yml', 'yaml' },
        settings = {
          yaml = {
            schemas = {
              ['https://raw.githubusercontent.com/helm-unittest/helm-unittest/main/schema/helm-testsuite.json'] = '*_test.yaml',
            },
          },
        },
      },
    }

    -- Ensure the servers and tools above are installed
    --  To check the current status of installed tools and/or manually install
    --  other tools, you can run
    --    :Mason
    --
    --  You can press `g?` for help in this menu
    require('mason').setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'bashls',
      'black',
      'dockerls',
      'eslint',
      'gopls',
      'isort',
      'jsonls',
      'lua_ls',
      'marksman',
      'prettier',
      'pyright',
      'rust_analyzer',
      'shfmt',
      'stylua',
      'taplo',
      'terraformls',
      'ts_ls',
      'yamlls',
    })

    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

          if server_name == 'eslint' then
            require('lspconfig')[server_name].setup(server)
          else
            vim.lsp.config(server_name, server)
            vim.lsp.enable(server_name)
          end
        end,
      },
    }
  end,
}
