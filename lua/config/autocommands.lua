vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  group = vim.api.nvim_create_augroup('custom-cursor-remember', { clear = true }),
  desc = 'return cursor to where it was last time closing the file',
  pattern = '*',
  command = 'silent! normal! g`"zvzz',
})

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- vim.api.nvim_create_autocmd('VimEnter', {
--   callback = function()
--     if vim.fn.argv(0) == '' then
--       require('telescope.builtin').find_files()
--     end
--   end,
-- })

vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Delete new lines at EOF',
  group = vim.api.nvim_create_augroup('delete-new-lines-eof', { clear = true }),
  callback = function()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    vim.cmd [[keepjumps keeppatterns silent! 0;/^\%(\n*.\)\@!/,$d_]]

    local num_rows = vim.api.nvim_buf_line_count(0)
    if cursor_pos[1] > num_rows then
      cursor_pos[1] = num_rows
    end

    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end,
})
