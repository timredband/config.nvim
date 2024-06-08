return {
  'folke/trouble.nvim',
  opts = {},
  cmd = 'Trouble',
  keys = {
    {
      '<leader>tt',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '[t',
      '<cmd>Trouble next<cr>',
    },
    {
      ']t',
      '<cmd>Trouble prev<cr>',
    },
  },
}
