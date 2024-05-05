return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup { use_icons = vim.g.have_nerd_font }

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    require('mini.files').setup {
      mappings = {
        synchronize = 'w',
        go_in_plus = '<CR>',
      },
      options = {
        use_as_default_explorer = true,
      },
    }
    vim.keymap.set('n', '-', function()
      require('mini.files').open(vim.api.nvim_buf_get_name(0))
    end, { desc = 'Open MiniFiles' })

    local show_dotfiles = true

    local filter_show = function()
      return true
    end

    local filter_hide = function(fs_entry)
      return not vim.startswith(fs_entry.name, '.')
    end

    local toggle_dotfiles = function()
      show_dotfiles = not show_dotfiles
      local new_filter = show_dotfiles and filter_show or filter_hide
      require('mini.files').refresh { content = { filter = new_filter } }
    end

    vim.api.nvim_create_autocmd('User', {
      group = vim.api.nvim_create_augroup('MiniFiles_buffer', { clear = true }),
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id
        vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
        vim.keymap.set('n', '-', require('mini.files').close, { buffer = buf_id })
      end,
    })

    local mini_git = require 'plugins.mini.mini-files-git'

    vim.api.nvim_create_autocmd('User', {
      group = vim.api.nvim_create_augroup('MiniFiles_start', { clear = true }),
      pattern = 'MiniFilesExplorerOpen',
      callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        mini_git.updateGitStatus(bufnr)
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      group = vim.api.nvim_create_augroup('MiniFiles_close', { clear = true }),
      pattern = 'MiniFilesExplorerClose',
      callback = function()
        mini_git.clearCache()
      end,
    })

    vim.api.nvim_create_autocmd('User', {
      group = vim.api.nvim_create_augroup('MiniFiles_update', { clear = true }),
      pattern = 'MiniFilesBufferUpdate',
      callback = function(sii)
        local bufnr = sii.data.buf_id
        local cwd = vim.fn.expand '%:p:h'
        local gitStatusCache = mini_git.getGitStatusCache()
        if gitStatusCache[cwd] then
          mini_git.updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
        end
      end,
    })

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
