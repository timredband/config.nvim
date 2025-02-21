vim.api.nvim_create_user_command('Substitute', function(args)
  if require('substitute').commands[args.args] == nil then
    vim.notify('Error: invalid arg', vim.log.levels.ERROR)
    return
  end

  vim.cmd(require('substitute').commands[args.args]['command'])
  require('substitute').create_substitute_window()
  require('luasnip').snip_expand(require('substitute').commands[args.args]['snippet'])
end, {
  nargs = 1,
  complete = function()
    return require('substitute').complete
  end,
})
