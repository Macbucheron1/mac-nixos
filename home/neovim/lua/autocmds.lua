vim.api.nvim_create_autocmd("TextYankPost", { -- Crée une action automatique après chaque yank/copie.
  desc = "Highlight when yanking (copying) text", -- Description lisible de l’autocommande.
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }), -- Crée/réinitialise un groupe pour éviter les doublons au reload.
  callback = function() -- Fonction exécutée quand l’événement se déclenche.
    vim.highlight.on_yank() -- Surligne brièvement le texte copié.
  end,
})

vim.api.nvim_create_autocmd("FileType", { -- Crée une action automatique quand un type de fichier est détecté.
  pattern = { "pager" }, -- Ne s’applique qu’aux buffers de type `pager`.
  callback = function() -- Fonction exécutée quand l’événement se déclenche.
    vim.opt.number = true -- Active les numéros de ligne.
    vim.opt.relativenumber = true -- Active les numéros de ligne relatifs.
  end,
})
