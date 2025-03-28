--- automatically go to first entry in quickfix on open
vim.schedule(function()
  vim.cmd [[cfirst]]
end)
