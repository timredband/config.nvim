local window = -1

local build = function()
  print 'Building solution'

  if window ~= -1 then
    vim.api.nvim_win_close(window, true)
    window = -1
  end

  local stdin = vim.uv.new_pipe(false)
  local stdout = vim.uv.new_pipe(false)
  local stderr = vim.uv.new_pipe(false)

  local handle
  local stdout_data = ''

  local function set_buffer_text(data)
    local row = 0
    local lines = {}
    local positions = {}

    for line in data:gmatch '([^\n]*)\n?' do
      table.insert(lines, line)

      local start = 1
      while true do
        local s, e = string.find(line, ': error', start, true)
        if not s then
          break
        end
        table.insert(positions, { row = row, start = s, stop = e, group = 'error' })
        start = e + 1
      end

      start = 1
      while true do
        local s, e = string.find(line, ': warning', start, true)
        if not s then
          break
        end
        table.insert(positions, { row = row, start = s, stop = e, group = 'warning' })
        start = e + 1
      end

      row = row + 1
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

    local ns = vim.api.nvim_create_namespace 'dotnet_build_colors'
    vim.api.nvim_set_hl(ns, 'error', { fg = 'red' })
    vim.api.nvim_set_hl(ns, 'warning', { fg = 'yellow' })
    vim.api.nvim_set_hl_ns(ns)

    for _, value in ipairs(positions) do
      vim.api.nvim_buf_set_extmark(0, ns, value.row, value.start, {
        end_col = value.stop,
        hl_group = value.group,
        invalidate = true,
      })
    end
  end

  handle = vim.uv.spawn('bash', {
    args = { '-c', 'cd ' .. vim.fn.expand '%:h' .. '; pwd; until fd -q sln; do cd ../; done; dotnet build;' },
    stdio = { stdin, stdout, stderr },
  }, function(code, signal)
    print('Process exited with code:', code)

    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    stdin:close()

    if handle then
      handle:close()
    end

    vim.schedule(function()
      local buffer = vim.api.nvim_create_buf(false, true)
      window = vim.api.nvim_open_win(buffer, true, { split = 'right' })
      vim.wo[window].wrap = true

      local escape_key = vim.api.nvim_replace_termcodes('<esc>', true, false, true)
      vim.keymap.set({ 'i', 'n' }, 'q', function()
        vim.api.nvim_feedkeys(escape_key, 'i', false)
        vim.api.nvim_win_close(window, false)
        window = -1
      end, { buffer = true })

      set_buffer_text(stdout_data)
    end)
  end)

  if handle then
    vim.uv.read_start(stdout, function(err, data)
      if err then
        print('stdout error: ', err)
        return
      end
      if data then
        stdout_data = stdout_data .. data
      end
    end)

    vim.uv.read_start(stderr, function(err, data)
      if err then
        print('stderr error: ', err)
        return
      end
      if data then
        print('stderr: ', data)
      end
    end)
  else
    print 'Failed to spawn process'
  end
end

return build
