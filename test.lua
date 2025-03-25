---comment
---@param line string
---@return string
---@return unknown
---@return unknown
---@return unknown
local getLocation = function(line)
  for filename, lineNumber, columnNumber, raw in string.gmatch(line, '([^:]+):(%d+):(%d+):(.*)') do
    return filename, tonumber(lineNumber), tonumber(columnNumber), raw
  end
end

---@class SearchResult
---@field line string
---@field path string
---@field raw integer
---@field column integer

-- rg -w --no-config --fixed-strings --ignore-case --column -o --json local --replace foo   | jq -s '[.[] | select(.type == "match") | {"path": .data.path.text,"text": .data.lines.text, "line_number": .data.line_number, "submatches": .data.submatches.[] | {"start": .start,"end":.end}}]'
-- rg -w --no-config --fixed-strings --ignore-case --column -o --json local --replace foo   | jq -s '[.[] | select(.type == "match") | {"path": .data.path.text,"text": .data.lines.text, "line_number": .data.line_number, "submatches": .data.submatches.[] | {"start": .start,"end":.end}}]| reduce .[] as $foo  ({}; .[$foo.path]+=[{"text": $foo.text, "line_number": $foo.line_number, "submatches": $foo.submatches}])'
-- local handle = io.popen 'rg --no-config --fixed-strings --ignore-case --vimgrep local'
local result = vim.system({ 'rg', '-w', '--no-config', '--fixed-strings', '--ignore-case', '--vimgrep', 'local' }, { text = true }):wait()
-- rg -w --no-config --fixed-strings --ignore-case --vimgrep local --replace foo
local out = result.code == 0 and result.stdout or result.stderr
local text = vim.split(vim.trim(out or ''), '\n')

local word = 'local'

local truncated = {}
local results_by_path = {}

for i, line in ipairs(text) do
  local filename, lineNumber, column, raw = getLocation(line)

  ---@type SearchResult
  local result = {
    line = lineNumber,
    path = filename,
    column = column,
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

local sorted = {}
for path in pairs(results_by_path) do
  table.insert(sorted, path)
end
table.sort(sorted)

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

for _, path in ipairs(sorted) do
  local results = results_by_path[path]

  local extension = string.match(path, '.*%.(.*)')
  local icon, highlight_name = require('nvim-web-devicons').get_icon(path, extension, { default = true })

  vim.api.nvim_buf_set_lines(buffer, i, i + 1, false, { path })

  vim.api.nvim_buf_set_extmark(buffer, ns, i, 0, {
    virt_text_pos = 'inline',
    virt_text = { { icon, highlight_name }, { ' ' } },
    invalidate = true,
  })

  vim.api.nvim_buf_set_extmark(buffer, ns, i, 0, {
    end_col = #path,
    hl_group = 'Directory',
    invalidate = true,
  })

  i = i + 1

  for _, value in ipairs(results) do
    local lines = {}
    table.insert(lines, '  ' .. string.sub(value.raw, 0, value.column - 1) .. string.sub(value.raw, value.column + #word))
    vim.api.nvim_buf_set_lines(buffer, i, i + 1, false, lines)

    vim.api.nvim_buf_set_extmark(buffer, ns, i, value.column - 1 + 2, {
      hl_group = 'old',
      invalidate = true,
      virt_text = { { word, 'old' } },
      virt_text_pos = 'inline',
    })

    vim.api.nvim_buf_set_extmark(buffer, ns, i, value.column - 1 + 2, {
      virt_text = { { 'foooooooooo', 'new' } },
      invalidate = true,
      virt_text_pos = 'inline',
    })

    i = i + 1
  end
end

-- vim.bo[buffer].modifiable = false

local window = vim.api.nvim_open_win(buffer, true, { split = 'below', height = 10 })
vim.wo.list = false

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
