return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'
    harpoon:setup()

    vim.keymap.set('n', '<leader>ha', function()
      harpoon:list():add()
    end, { desc = '[H]arpoon: [A]dd file to harpoon list' })
    vim.keymap.set('n', '<leader>hl', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = '[H]arpoon: Toggle [L]ist' })

    vim.keymap.set('n', '<C-h>', function()
      harpoon:list():select(1)
    end, { desc = 'Harpoon: 1' })
    vim.keymap.set('n', '<C-j>', function()
      harpoon:list():select(2)
    end, { desc = 'Harpoon: 2' })
    vim.keymap.set('n', '<C-k>', function()
      harpoon:list():select(3)
    end, { desc = 'Harpoon: 3' })
    vim.keymap.set('n', '<C-l>', function()
      harpoon:list():select(4)
    end, { desc = 'Harpoon: 4' })
    vim.keymap.set('n', '<M-h>', function()
      harpoon:list():select(5)
    end, { desc = 'Harpoon: 5' })
    vim.keymap.set('n', '<M-j>', function()
      harpoon:list():select(6)
    end, { desc = 'Harpoon: 6' })
    vim.keymap.set('n', '<M-k>', function()
      harpoon:list():select(7)
    end, { desc = 'Harpoon: 7' })
    vim.keymap.set('n', '<M-l>', function()
      harpoon:list():select(8)
    end, { desc = 'Harpoon: 8' })
  end,
}
