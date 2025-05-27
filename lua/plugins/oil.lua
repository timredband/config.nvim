return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    keymaps = {
      ['<C-h>'] = { 'actions.parent', mode = 'n' },
      ['<C-l>'] = { 'actions.select', mode = 'n' },
      ['<C-s>'] = {},
      ['Q'] = { 'actions.close', mode = 'n' },
    },
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, bufnr)
        return name == '.git'
      end,
    },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false,
  keys = {
    { '-', '<cmd>Oil<cr>', desc = 'Open Oil' },
  },
}
