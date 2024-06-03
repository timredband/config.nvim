-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    current_line_blame = true,
  },
  config = function(_, opts)
    opts.on_attach = function()
      local gitsigns = require 'gitsigns'
      vim.keymap.set('n', '<leader>td', gitsigns.toggle_deleted)
      vim.keymap.set('n', '<leader>tD', gitsigns.diffthis)
      vim.keymap.set('n', '<leader>tr', gitsigns.reset_hunk)

      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Go to next diff hunk' })

      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Go to prev diff hunk' })
    end

    require('gitsigns').setup(opts)
  end,
}
