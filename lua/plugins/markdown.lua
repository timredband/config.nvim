vim.cmd [[
  function OpenMarkdownPreview (url)
    let localhost_url = substitute(a:url, "^.*:", "http://localhost:", "")
    execute "silent ! ~/links/chrome.exe --new-window " . l:localhost_url
  endfunction
]]

return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && yarn install',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
    vim.g.mkdp_browserfunc = 'OpenMarkdownPreview'
  end,
  ft = { 'markdown' },
}
