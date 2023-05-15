require("mason").setup()
require("mason-lspconfig").setup(
{ ensure_installed = {"lua_ls", "pyright", "marksman", "yamlls", "sqlls", "dockerls","jsonls"} 
})
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("lspconfig").lua_ls.setup {
  capabilities = capabilities
}






