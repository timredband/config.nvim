return { -- Autoformat
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_fallback = true }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = {
      timeout_ms = 1000,
      lsp_fallback = true,
    },
    formatters_by_ft = {
      bash = { 'shfmt' },
      css = { 'biome' },
      dockerfile = { 'dockerfmt' },
      html = { 'biome' },
      javascript = { 'biome' },
      -- json = { 'jq' },
      lua = { 'stylua' },
      markdown = { 'prettier' },

      -- yaml = { 'yq' },

      -- Conform can also run multiple formatters sequentially
      -- python = { 'autopep8' },
      python = { 'isort', 'black' },
      -- python = { 'ruff' },
      scss = { 'prettier' },
      sh = { 'shfmt' },
      sql = { 'pg_format' },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
      -- javascript = { { "prettierd", "prettier" } },
    },
    formatters = {
      pg_format = {
        prepend_args = function()
          return { '--comma-start' }
        end,
      },
      -- yq = {
      --   prepend_args = function()
      --     return { 'sort_keys(..) | (.. | select(type == "!!seq")) |= sort', '-P', '-' }
      --   end,
      --   format_on_save = false,
      -- },
    },
  },
}
