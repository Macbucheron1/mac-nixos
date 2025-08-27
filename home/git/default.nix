{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName  = "macbucheron1";
    userEmail = "nathandeprat@hotmail.fr";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}