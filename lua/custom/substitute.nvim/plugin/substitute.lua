vim.api.nvim_create_user_command('Substitute', function()
  require('substitute').open()
end, {})
