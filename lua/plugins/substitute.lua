return {
  dependencies = {
    'L3MON4D3/LuaSnip',
  },
  lazy = false,
  dir = '~/.config/nvim/lua/custom/substitute.nvim',
  opts = {},
  keys = {
    { '<leader>S', '<cmd>Substitute normal<cr>', mode = 'n', desc = 'Substitute normal' },
    { '<leader>S', '<cmd>Substitute visual<cr>', mode = 'v', desc = 'Substitute visual' },
  },
}
