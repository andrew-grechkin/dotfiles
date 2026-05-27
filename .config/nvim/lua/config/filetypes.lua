vim.filetype.add({
    extension = {gotmpl = 'gotmpl', tmpl = 'helm'},
    pattern = {
        ['.*/templates/.*%.tmpl'] = 'helm',
        ['.*/templates/.*%.ya?ml'] = 'helm',
        ['helmfile.*%.ya?ml'] = 'helm',
    },
})
