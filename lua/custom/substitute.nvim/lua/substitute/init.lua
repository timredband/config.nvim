local M = {}

local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local snippets = {
  word = s('word', {
    t [[:]],
    i(2, '0'),
    t [[,]],
    i(3, '$'),
    t [[s/\<]],
    f(function()
      return vim.fn.getreg 'x'
    end),
    t [[\>/]],
    i(1),
    t [[/gIc]],
  }),
  selection = s('selection', {
    t [[:]],
    i(2, '0'),
    t [[,]],
    i(3, '$'),
    t [[s/]],
    f(function()
      return vim.fn.getreg 'x'
    end),
    t [[/]],
    i(1),
    t [[/gIc]],
  }),
}

local actions_by_mode = {
  n = {
    command = [[silent normal! "xyiw]],
    snippet = snippets['word'],
  },
  v = {
    command = [[silent normal! "xy]],
    snippet = snippets['selection'],
  },
}

---@return { buf_id: number, win_id: number }
local function create_substitute_window()
  local buffer = vim.api.nvim_create_buf(false, true)
  local window = vim.api.nvim_open_win(buffer, true, { split = 'below', height = 1 })

  return { buf_id = buffer, win_id = window }
end

---@param window { buf_id: number, win_id: number }
local function create_substitute_window_keymaps(window)
  local escape_key = vim.api.nvim_replace_termcodes('<esc>', true, false, true)

  vim.keymap.set({ 'i', 'n' }, '<cr>', function()
    vim.api.nvim_feedkeys(escape_key, 'i', false)
    vim.cmd [[normal! ^"xy$]]
    vim.api.nvim_win_close(window.win_id, false)
    vim.api.nvim_feedkeys(vim.fn.getreg 'x', 't', false)
  end, { buffer = true })

  vim.keymap.set({ 'i', 'n' }, 'Q', function()
    vim.api.nvim_feedkeys(escape_key, 'i', false)
    vim.api.nvim_win_close(window.win_id, false)
  end, { buffer = true })

  vim.keymap.set({ 's' }, 'x', function()
    vim.api.nvim_feedkeys(escape_key, 'i', false)
    vim.api.nvim_feedkeys('xi', 'n', true)
  end, { buffer = true })
end

local function strip_trailing_newline()
  local yanked = vim.fn.getreg 'x'

  if yanked:sub(#yanked) == '\n' then
    vim.fn.setreg('x', yanked:sub(0, #yanked - 1))
  end
end

function M.open()
  local mode = vim.api.nvim_get_mode().mode

  if mode == 'v' or mode == 'V' then
    local visual_start = vim.fn.getpos 'v'
    local visual_end = vim.fn.getpos '.'

    if visual_start[2] ~= visual_end[2] then
      -- row mismatch
      vim.notify('Error: row mismatch', vim.log.levels.ERROR)
      return
    end

    mode = 'v'
  end

  if actions_by_mode[mode] == nil then
    vim.notify('Error: unsupported mode', vim.log.levels.ERROR)
    return
  end

  vim.cmd(actions_by_mode[mode]['command'])
  strip_trailing_newline()

  local substitute_window = create_substitute_window()
  create_substitute_window_keymaps(substitute_window)

  require('luasnip').snip_expand(actions_by_mode[mode]['snippet'])
end

function M.setup() end

return M
