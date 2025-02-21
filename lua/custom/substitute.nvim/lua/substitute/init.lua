local M = {}

local function create_snippets()
  local ls = require 'luasnip'
  local s = ls.snippet
  local t = ls.text_node
  local i = ls.insert_node
  local f = ls.function_node

  local snippets = {
    word = s('word', {
      t [[:]],
      i(2, '%'),
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
      i(2, '%'),
      t [[s/]],
      f(function()
        return vim.fn.getreg 'x'
      end),
      t [[/]],
      i(1),
      t [[/gIc]],
    }),
  }

  return snippets
end

local function create_user_commands(snippets)
  local commands = {
    normal = {
      command = [[normal! "xyiw]],
      snippet = snippets['word'],
    },
    visual = {
      command = [[normal! "xy]],
      snippet = snippets['selection'],
    },
  }

  return commands
end

local function create_user_command_complete(commands)
  local complete = {}

  for command in pairs(commands) do
    table.insert(complete, command)
  end

  table.sort(complete)

  return complete
end

local function create_substitute_window()
  local buffer = vim.api.nvim_create_buf(false, true)
  local window = vim.api.nvim_open_win(buffer, true, { split = 'below', height = 1 })
  local escape_key = vim.api.nvim_replace_termcodes('<esc>', true, false, true)

  vim.keymap.set({ 'i', 'n' }, '<cr>', function()
    vim.api.nvim_feedkeys(escape_key, 'i', false)
    vim.cmd [[normal! ^"xy$]]
    vim.api.nvim_win_close(window, false)
    vim.api.nvim_feedkeys(vim.fn.getreg 'x', 't', false)
  end, { buffer = true })

  vim.keymap.set({ 'i', 'n' }, 'Q', function()
    vim.api.nvim_feedkeys(escape_key, 'i', false)
    vim.api.nvim_win_close(window, false)
  end, { buffer = true })
end

local function create_user_command()
  local snippets = create_snippets()
  local commands = create_user_commands(snippets)
  local complete = create_user_command_complete(commands)

  vim.api.nvim_create_user_command('Substitute', function(args)
    if commands[args.args] == nil then
      vim.notify('Error: invalid arg', vim.log.levels.ERROR)
      return
    end

    vim.cmd(commands[args.args]['command'])
    create_substitute_window()
    require('luasnip').snip_expand(commands[args.args]['snippet'])
  end, {
    nargs = 1,
    complete = function()
      return complete
    end,
  })
end

function M.setup()
  create_user_command()
end

return M
