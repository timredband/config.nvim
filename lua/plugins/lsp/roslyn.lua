local window = -1

local build = function()
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
    local lines = {}
    for line in data:gmatch '([^\n]*)\n?' do
      table.insert(lines, line)
    end
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  end

  handle = vim.uv.spawn('bash', {
    args = { '-c', 'until fd -q sln; do cd ../; done; dotnet build;' },
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
