return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
    },
    {
      'nvim-treesitter/nvim-treesitter-context',
    },
  },
  config = function()
    require('nvim-treesitter.install').prefer_git = true

    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'yaml', 'vim', 'vimdoc' },
      auto_install = true,
      highlight = {
        enable = true,
        disable = function(_, bufnr)
          local max_filesize = 1024 * 1024
          local filename = vim.api.nvim_buf_get_name(bufnr)

          local ok, stats = pcall(vim.loop.fs_stat, filename)

          if ok and stats and stats.size > max_filesize then
            return true
          end

          return false
        end,
      },
      indent = { enable = true, disable = { 'yaml' } },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
          },
        },
      },
    }

    require('treesitter-context').setup {
      enable = false,
    }

    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  end,
}
