vim.filetype.add({
    extension = {
        mess = 'aster',
        comm = 'aster',
        qml = 'qmljs',
    },
    filename = {
        ['.gitlab-ci.yml'] = 'yaml.gitlab',
    },
})
