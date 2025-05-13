return {
  "mfussenegger/nvim-dap",
  lazy = false,
  dependencies = {
    "rcarriga/nvim-dap-ui",
    {
      "microsoft/vscode-js-debug",
      build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
    },
    {
      "mxsdev/nvim-dap-vscode-js",
      config = function()
        require "configs.dap-vscode-js"
      end,
    },
    {
      "Joakker/lua-json5",
      build = "./install.sh",
    },
  },
  config = function()
    require "configs.dap"
  end,
}
