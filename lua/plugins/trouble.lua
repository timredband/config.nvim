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
      '<cmd>Trouble diagnostics next<cr><cmd>Trouble diagnostics jump<cr>',
    },
    {
      ']t',
      '<cmd>Trouble diagnostics prev<cr><cmd>Trouble diagnostics jump<cr>',
    },
  },
}
