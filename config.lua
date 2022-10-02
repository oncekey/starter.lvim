lvim.log.level = "warn"
lvim.format_on_save = false
lvim.leader = "space"
lvim.lsp.diagnostics.virtual_text = true

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.breadcrumbs.active = true
lvim.builtin.treesitter.highlight.enable = true
-- enable dap
lvim.builtin.dap.active = true

-- auto install treesitter parsers
lvim.builtin.treesitter.ensure_installed = { "cpp", "c" }


vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "clangd" })

-- setup clangd

-- customize clangd by changing the flags below
local clangd_flags = {
  "--background-index",
  "--fallback-style=google",
  "--all-scopes-completion",
  "--clang-tidy",
  "--log=error",
  "--completion-style=detailed",
  "--pch-storage=disk",
  "--folding-ranges",
  "--enable-config",
}


require("lvim.lsp.manager").setup("clangd", {
  cmd = { "clangd", unpack(clangd_flags) },
  on_attach = require("lvim.lsp").common_on_attach,
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities()
})

-- install codelldb with :MasonInstall codelldb
-- configure nvim-dap (codelldb)
lvim.builtin.dap.on_config_done = function(dap)
  local codelldb_cmd = vim.fn.stdpath "data" .. "/mason/packages/codelldb/extension/adapter/codelldb"

  dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
      command = codelldb_cmd,
      args = { "--port", "${port}" },

      -- On windows you may have to uncomment this:
      -- detached = false,
    }
  }

  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = true,
    },
  }

  dap.configurations.c = dap.configurations.cpp
end
