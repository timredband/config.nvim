if vim.fn.expand '%' == 'package.json' then
  vim.keymap.set('n', 'gx', function()
    vim.cmd [[normal "yyiq]]
    vim.ui.open('https://www.npmjs.com/package/' .. vim.fn.getreg 'y')
  end, { buffer = true })
end
