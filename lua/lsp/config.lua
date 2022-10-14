local config = {}

local servers = {
  "sumneko_lua",
  "pyright",
}

local mason_settings = {
  ui = {
    border = "rounded",
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}
function config.nvim_cmp()
  local cmp = require('cmp')
  cmp.setup({
    preselect = cmp.PreselectMode.Item,
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    formatting = {
      fields = { 'abbr', 'kind', 'menu' },
    },
    -- You can set mappings if you want
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'path' },
      { name = 'buffer' },
    },
  })

end

function config.load_cmp()
  require("mason").setup(mason_settings)
  require("mason-lspconfig").setup({
    ensure_installed = servers
  })


  local lspconfig = require('lspconfig')
  local opts = {}
  for _, server in pairs(servers) do
    opts = {
      on_attach = require("lsp.handlers").on_attach,
      capabilities = require("lsp.handlers").capabilities,
    }

    if server == "sumneko_lua" then
      opts = vim.tbl_deep_extend("force", {
      settings = {
      Lua = {
      diagnostics = {
	globals = {'vim'}
      }}}}, opts)
    end

    server = vim.split(server, "@")[1]
    lspconfig[server].setup(opts)
    ::continue::
  end
end

return config
