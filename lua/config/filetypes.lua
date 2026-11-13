vim.filetype.add {
  extension = {
    bats = 'bash',
    tfvars = 'terraform',
  },
  filename = {
    ['.pactrc'] = 'bash',
    ['helmfile.yaml'] = 'helm',
  },
  pattern = {
    ['.*/templates/.*%.ya?ml'] = 'helm',
    ['.*/templates/.*%.tpl'] = 'helm',
    ['helmfile.*%.ya?ml'] = 'helm',
  },
}
