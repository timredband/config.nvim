-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>l', vim.diagnostic.setloclist, { desc = 'Open diagnostic [L]ocation list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '0', '^')

local function visual_keep_cursor(command)
  vim.cmd [[normal! "vy]]
  vim.cmd(command .. [[\V]] .. vim.fn.getreg 'v')
  vim.schedule(function()
    vim.cmd [[keepjumps normal! N]]
  end)
end

-- when using * or # stay on searched word
vim.keymap.set('n', '*', '<cmd>keepjumps normal! *N<CR>')
vim.keymap.set('n', '#', '<cmd>keepjumps normal! #N<CR>')
vim.keymap.set('v', '*', function()
  visual_keep_cursor '/'
end)
vim.keymap.set('v', '#', function()
  visual_keep_cursor '?'
end)

-- Write with Control-S
vim.keymap.set({ 'i', 'v', 'c', 'n' }, '<C-s>', '<esc><cmd>w<cr>', { desc = 'Write file' })

-- Write {}
vim.keymap.set('i', '<C-j>', '{}', { desc = 'Write {}' })

-- center cursor while moving through it
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- move through file slightly faster
vim.keymap.set('n', '<C-e>', '8<C-e>')
vim.keymap.set('n', '<C-y>', '8<C-y>')

vim.keymap.set('n', 'n', 'nzvzz')
vim.keymap.set('n', 'N', 'Nzvzz')

-- move through quickfix list easier
vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>zvzz')
vim.keymap.set('n', '<C-m>', '<cmd>cprev<CR>zvzz')

-- move through location list easier with
vim.keymap.set('n', '<M-n>', '<cmd>lnext<CR>zvzz')
vim.keymap.set('n', '<M-m>', '<cmd>lprev<CR>zvzz')

-- close quicklist, location list, trouble list easier
vim.keymap.set('n', 'Q', '<cmd>cclose<CR><cmd>lclose<CR><cmd>Trouble close<CR>')

-- [p]aste over [w]ord
vim.keymap.set('n', '<leader>pw', function()
  return '"_ciw' .. vim.fn.getreg('0'):gsub('\n', '') .. '<esc>'
end, { expr = true })
vim.keymap.set('n', '<leader>pW', function()
  return '"_ciw' .. vim.fn.getreg('"'):gsub('\n', '') .. '<esc>'
end, { expr = true })

-- [p]aste over [q]uoted strings
vim.keymap.set('n', '<leader>pq', function()
  local command = [[normal "_ciq]] .. vim.fn.getreg('0'):gsub('\n', '')
  vim.cmd(command)
end)
vim.keymap.set('n', '<leader>pQ', function()
  local command = [[normal "_ciq]] .. vim.fn.getreg('"'):gsub('\n', '')
  vim.cmd(command)
end)

-- [p]aste last [y]ank
vim.keymap.set('n', '<leader>py', [["0p]])
vim.keymap.set('n', '<leader>Py', [["0P]])

-- [y]ank into system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+y$]])

-- [p]aste from system [c]lipboard
vim.keymap.set('n', '<leader>pc', [["+p]])
vim.keymap.set('n', '<leader>Pc', [["+P]])

-- [p]aste two lines down
vim.keymap.set('n', '<leader>po', [[o<esc>"0p]])
vim.keymap.set('n', '<leader>pO', [[o<esc>""p]])

-- toggle fold method
vim.keymap.set('n', '<leader>zt', function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt_local.foldmethod:get() == 'manual' then
    vim.opt_local.foldmethod = 'indent'
    return 'zM'
  else
    vim.opt_local.foldmethod = 'manual'
    return 'zR'
  end
end, { expr = true })

vim.keymap.set('n', '<leader>dt', function()
  local config = vim.diagnostic.config
  local vt = config().virtual_text
  config {
    virtual_text = not vt,
    underline = not vt,
    signs = not vt,
  }
end, { desc = '[D]iagnostic [T]oggle' })

-- source current file
vim.keymap.set('n', '<leader><leader>x', [[<cmd>source %<cr>]])
