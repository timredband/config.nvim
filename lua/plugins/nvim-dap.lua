return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-neotest/nvim-nio',
    'NicholasMata/nvim-dap-cs',
  },
  config = function()
    local dap = require 'dap'
    local ui = require 'dapui'

    require('dapui').setup()
    require('nvim-dap-virtual-text').setup()

    require('dap-cs').setup {
      dap_configurations = {
        {
          type = 'coreclr',
          name = 'Attach remote',
          mode = 'remote',
          request = 'attach',
        },
      },
      netcoredbg = {
        path = '/home/tim/.local/share/nvim/mason/packages/netcoredbg/libexec/netcoredbg/netcoredbg',
      },
    }

    vim.keymap.set('n', '<leader><leader>b', dap.toggle_breakpoint)
    vim.keymap.set('n', '<leader><leader>gb', dap.run_to_cursor)

    vim.keymap.set('n', '<F1>', dap.continue, { desc = 'Continue' })
    vim.keymap.set('n', '<F2>', dap.step_into, { desc = 'Step into' })
    vim.keymap.set('n', '<F3>', dap.step_over, { desc = 'Step over' })
    vim.keymap.set('n', '<F4>', dap.step_out, { desc = 'Step out' })
    vim.keymap.set('n', '<F5>', dap.step_back, { desc = 'Step back' })
    vim.keymap.set('n', '<F6>', dap.restart, { desc = 'Restart' })

    dap.listeners.before.attach.dapui_config = function()
      ui.open()
    end

    dap.listeners.before.launch.dapui_config = function()
      ui.open()
    end

    dap.listeners.before.event_terminated.dapui_config = function()
      ui.close()
    end

    dap.listeners.before.event_exited.dapui_config = function()
      ui.close()
    end
  end,
}
