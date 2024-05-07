-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

--  remove these for now in favor of using <C-hjkl> for harpoon
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '0', '^')

-- Write with Control-S
vim.keymap.set({ 'i', 'v', 'c', 'n' }, '<C-s>', '<esc><cmd>w<cr>', { desc = 'Write file' })

-- center cursor while moving through it
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- move through file slightly faster
vim.keymap.set('n', '<C-e>', '2<C-e>')
vim.keymap.set('n', '<C-y>', '2<C-y>')

vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Replace word under cursor in file
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('v', '<leader>s', [["xy:%s/<C-r>x/<C-r>x/gI<Left><Left><Left>]])

-- move through quickfix list easier
vim.keymap.set('n', '<C-n>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-m>', '<cmd>cprev<CR>zz')

-- [p]aste over [w]ord
vim.keymap.set('n', '<leader>pw', [[ciw<C-r>0<esc>]])
-- [p]aste over [s]ingle quoted string
vim.keymap.set('n', '<leader>ps', [[ci'<C-r>0<esc>]])
-- [p]aste over [d]ouble quoted string
vim.keymap.set('n', '<leader>pd', [[ci"<C-r>0<esc>]])

-- [p]aste last [y]ank
vim.keymap.set('n', '<leader>py', [["0p]])
vim.keymap.set('n', '<leader>Py', [["0P]])

-- yank into system clipboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+y$]])

-- [p]aste from system [c]lipboard
vim.keymap.set('n', '<leader>pc', [["+p]])
vim.keymap.set('n', '<leader>Pc', [["+P]])
