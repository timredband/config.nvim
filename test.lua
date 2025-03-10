---comment
---@param line string
---@return string
---@return unknown
---@return unknown
---@return unknown
local getLocation = function(line)
  for filename, lineNumber, columnNumber, raw in string.gmatch(line, '([^:]+):(%d+):(%d+):(.*)') do
    return filename, lineNumber, columnNumber, raw
  end
end

---@class SearchResult
---@field line string
---@field path string
---@field raw integer
---@field column integer

local handle = io.popen 'rg -i --vimgrep local'
local word = 'local'

if handle == nil then
  os.exit(false)
end

local truncated = {}
local results_by_path = {}

for line in handle:lines() do
  local filename, lineNumber, column, raw = getLocation(line)

  ---@type SearchResult
  local result = {
    line = lineNumber + 0,
    path = filename,
    column = column + 0,
    raw = raw,
  }

  --- bar a, bar b, bar c,bar d

  if results_by_path[result.path] == nil then
    results_by_path[result.path] = {}
  end

  table.insert(results_by_path[result.path], result)
  -- table.insert(truncated, string.sub(result.raw, 0, result.column - 1) .. string.sub(result.raw, result.column + #word))
  -- table.insert(truncated, result.raw)
end

for _, value in pairs(results_by_path) do
  table.sort(value, function(a, b)
    if a.line == b.line then
      return a.column - b.column < 0
    end

    return a.line - b.line < 0
  end)
end

handle:close()

-- print(vim.inspect(results_by_path))
-- print(vim.inspect(truncated))

local buffer = vim.api.nvim_create_buf(false, true)
--
--
--
-- -- vim.api.nvim_buf_set_extmark(0, ns_id, 2, 5, { hl_group = 'foobar' })
--
-- -- print(result)
-- --
--
--
local ns = vim.api.nvim_create_namespace 'my_namespace'
vim.api.nvim_set_hl(ns, 'old', { bg = 'darkred', strikethrough = true })
vim.api.nvim_set_hl(ns, 'new', { bg = 'darkgreen' })
vim.api.nvim_set_hl_ns(ns)

local i = 0
for path, results in pairs(results_by_path) do
  vim.api.nvim_buf_set_lines(buffer, i, i + 1, false, { path })
  i = i + 1

  for _, value in ipairs(results) do
    local lines = {}
    table.insert(lines, '  ' .. string.sub(value.raw, 0, value.column - 1) .. string.sub(value.raw, value.column + #word))
    vim.api.nvim_buf_set_lines(buffer, i, i + 1, false, lines)

    vim.api.nvim_buf_set_extmark(buffer, ns, i, value.column - 1 + 2, {
      hl_group = 'old',
      virt_text = { { word, 'old' } },
      virt_text_pos = 'inline',
    })

    vim.api.nvim_buf_set_extmark(buffer, ns, i, value.column - 1 + 2, {
      virt_text = { { 'foooooooooo', 'new' } },
      virt_text_pos = 'inline',
    })
    i = i + 1
  end
end

vim.bo[buffer].modifiable = false

local window = vim.api.nvim_open_win(buffer, true, { split = 'below', height = 10 })

-- -- vim.api.nvim_buf_set_extmark(0, ns, 1, 5, {
-- --   end_col = 10,
-- --   hl_group = 'DiffDelete',
-- --
-- --   virt_text = { { 'foo', '' } },
-- --   virt_text_pos = 'inline',
-- -- })
--
-- -- for match in string.gmatch(test, '[^:]*[^:]*[^:]*') do
-- --   print(match)
-- -- end
-- -- local t = {} -- table to store the indices
-- -- ---@type integer | nil
-- -- local i = 0
-- -- while true do
-- --   i = string.find(l, 'local', i + 1) -- find 'next' newline
-- --   if i == nil then
-- --     break
-- --   end
-- --   table.insert(t, i)
-- -- end
-- -- for match in string.gmatch(l, 'local') do
-- -- end
-- -- print(loc)
-- -- end
--
-- -- local re = vim.regex 'local'
-- -- local m = re:match_line(buffer, 2)
-- -- re:match_str 'local'
-- -- print(m)
-- -- -- re:print(re)
-- --
-- -- -- vim.api.nvim_buf_clear_namespace(buffer, ns, 0, -1)
