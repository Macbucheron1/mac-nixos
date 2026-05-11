vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.tabstop = 2        -- Affiche une tabulation comme 2 espaces.
vim.opt.softtabstop = 2    -- En mode insertion, Tab/Backspace se comportent comme 2 espaces.
vim.opt.shiftwidth = 2     -- Indentation automatique avec 2 espaces.
vim.opt.expandtab = true   -- Convertit les tabulations en espaces.
vim.opt.smartindent = false -- Désactive l’indentation intelligente générique de Vim.
vim.opt.cindent = true     -- Active l’indentation spécifique aux langages de type C.

vim.opt.number = true          -- Affiche le numéro absolu de la ligne courante.
vim.opt.relativenumber = true  -- Affiche les numéros relatifs sur les autres lignes, utile pour les mouvements comme 5j/3k.

vim.opt.mouse = "a" -- Active la souris dans tous les modes : normal, insertion, visuel, ligne de commande.

vim.opt.showmode = false -- Cache l’indicateur de mode `-- INSERT --`, utile si ta statusline l’affiche déjà.

vim.opt.fillchars:append({ eob = " " }) -- Remplace les `~` en fin de buffer par des espaces, donc les lignes vides paraissent propres.

vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end) -- Configure le presse-papiers système après le démarrage, pour utiliser copier/coller avec le clipboard de l’OS.

vim.opt.wrap = true -- Retourne visuellement les longues lignes à l’écran.
vim.opt.breakindent = true -- Indente les lignes visuellement coupées selon l’indentation de la ligne originale.

vim.opt.undofile = true -- Sauvegarde l’historique d’annulation entre les sessions.
vim.opt.undolevels = 10000 -- Garde jusqu’à 10000 niveaux d’annulation.

vim.opt.ignorecase = true -- Rend les recherches insensibles à la casse.
vim.opt.smartcase = true -- Rend la recherche sensible à la casse si tu utilises une majuscule.

vim.opt.updatetime = 250 -- Réduit le délai d’actualisation interne, utile pour diagnostics et plugins.
vim.opt.timeoutlen = 300 -- Réduit le délai d’attente pour les mappings composés.

vim.opt.signcolumn = "yes" -- Garde toujours la colonne des signes visible à gauche.

vim.opt.splitright = true -- Ouvre les splits verticaux à droite.
vim.opt.splitbelow = true -- Ouvre les splits horizontaux en bas.

vim.opt.list = true -- Affiche certains caractères invisibles.
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- Définit l’affichage des tabs, espaces finaux et espaces insécables.

vim.opt.cursorline = false -- N’affiche pas de surbrillance sur la ligne courante.

vim.opt.scrolloff = 10 -- Garde 10 lignes visibles au-dessus et en dessous du curseur.

vim.opt.confirm = true -- Demande confirmation au lieu d’échouer lors d’actions avec fichiers non sauvegardés.

vim.diagnostic.config({
  virtual_lines = true,
  virtual_text = false,
}) -- Affiche les diagnostics sur des lignes virtuelles plutôt qu’en texte inline.

vim.g.autoformat = false -- Définit une variable globale pour désactiver l’autoformat, si ta config ou tes plugins l’utilisent.
