local ctags_binpath = vim.fn.stdpath('data')..'/ctags'

-- Fonction de téléchargement de ctags si non présent
local ensure_ctags = function()
    local fn = vim.fn
    if fn.empty(fn.glob(ctags_binpath)) > 0 then
        print("Impossible de localiser ctags dans " .. ctags_binpath)
        print("merci de l'installer pour pouvoir utiliser tagbar")
        return false
    end
    return false
end

-- Lancement de la fonction de téléchargement de ctags si nécessaire
ensure_ctags()

-- set du path de l'executable ctags nécessaire pour tagbar
vim.g.tagbar_ctags_bin = ctags_binpath
