require 'config'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = {
    import = 'plugins',
  },
  change_detection = {
    enabled = false,
    notify = false,
  },
}

-- :syntax match NonASCII "[^\x00-\x7F]"
-- :highlight NonASCII ctermbg=red guibg=red
