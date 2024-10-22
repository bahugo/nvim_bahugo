vim.filetype.add({
    extension = {
        mess = 'aster',
        comm = 'aster',
        qml = 'qmljs',
    },
    pattern = {
        ["%.gitlab%-ci.*.yml"] = 'yaml.gitlab',
    },
    filename = {
        ['.astro.config.mjs'] = 'astro',
    },
})
