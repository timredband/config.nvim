--- automatically go to first entry if new quickfix
vim.schedule(function()
  local pos = vim.api.nvim_win_get_cursor(0)

  if pos[1] == 1 then
    vim.cmd [[cfirst]]
  end
end)
