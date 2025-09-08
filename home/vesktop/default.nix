{ pkgs, ... }:
{
  # 2) Dis à Vencord d'utiliser le QuickCSS (sinon… rien ne s’applique)
  programs.vesktop = {
    enable = true;
    vencord.settings = {
      useQuickCss = true;   # indispensable
      # tu peux ajouter d'autres réglages/plugins ici
    };
    # Optionnel : tu peux aussi déclarer des thèmes Vencord ici
    # vencord.themes = [ ... ];
  };
}
