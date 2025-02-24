return {
  dependencies = {
    'L3MON4D3/LuaSnip',
  },
  lazy = false,
  dir = '~/.config/nvim/lua/custom/substitute.nvim',
  opts = {},
  keys = {
    { '<leader>S', '<cmd>Substitute<cr>', mode = { 'n', 'v' }, desc = 'Substitute' },
  },
}
