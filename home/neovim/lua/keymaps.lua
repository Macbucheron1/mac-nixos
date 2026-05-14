vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- En mode normal, Échap enlève le surlignage de recherche.
vim.keymap.set("x", "p", '"_dP') -- En mode visuel, colle par-dessus sans remplacer le registre de copie.

vim.keymap.set({"n", "v"}, "H", "^") -- En mode normal, H va au premier caractère non blanc de la ligne.
vim.keymap.set({"n", "v"}, "L", "$") -- En mode normal, L va à la fin de la ligne.

vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true }) -- Descend visuellement avec les lignes wrap, sauf si un compteur est donné.
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true }) -- Même chose que `j`, mais avec la flèche bas.
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true }) -- Monte visuellement avec les lignes wrap, sauf si un compteur est donné.
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true }) -- Même chose que `k`, mais avec la flèche haut.

vim.keymap.set("v", "<", "<gv") -- Désindente en visuel puis garde la sélection.
vim.keymap.set("v", ">", ">gv") -- Indente en visuel puis garde la sélection.

vim.keymap.set("n", "<M-Tab>", "<cmd>bp<CR>")
vim.keymap.set("n", "<Tab>", "<cmd>bn<CR>")
