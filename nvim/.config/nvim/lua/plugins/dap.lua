return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
    {
      "willamboman/mason.nvim",
      ensure_installed = { "js-debug-adapter" },
    },
  },
  event = "VeryLazy",
  config = function()
    local dap, dapui = require "dap", require "dapui"

    dapui.setup()
    dap.listeners.before.attach.dapui_coonfig = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_coonfig = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set("n", "<leader>kb", dap.toggle_breakpoint, { desc = "[DAP] Toggle breakpoint" })
    vim.keymap.set("n", "<leader>kc", dap.continue, { desc = "[DAP] Run/Continue" })
    vim.keymap.set("n", "<leader>ko", dap.step_over, { desc = "[DAP] Step over" })
    vim.keymap.set("n", "<leader>ki", dap.step_into, { desc = "[DAP] Step into" })
    vim.keymap.set("n", "<leader>kO", dap.step_out, { desc = "[DAP] Step out" })
    vim.keymap.set("n", "<leader>kB", dap.step_back, { desc = "[DAP] Step back" })
    vim.keymap.set("n", "<leader>kr", dap.restart, { desc = "[DAP] Restart" })
    -- vim.keymap.set('n','<leader>k', dap. ,{desc="[DAP] "})

    -- local js_vscode_debug = vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter"
    -- if js_vscode_debug ~= "" then
    --   dap.adapters.jsts_executable = {
    --     type = "executable",
    --     command = js_vscode_debug,
    --   }
    --   dap.configurations.javascript = {
    --     type = "jsts_executable",
    --     name = "jsts_executable",
    --     request = "launch",
    --     projectDir = "{$workspaceFolder}",
    --     exitAfterTaskReturns = false,
    --     debugAutoInterpretAllModules = false,
    --   }
    -- end
  end,
}
