{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    settings = { 
      user = {
        name  = "macbucheron1";
        email = "nathandeprat@hotmail.fr";
      };
      init.defaultBranch = "main";
      pull.rebase = true;

      commit.gpgsign = true;

      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519";
    };

  };
}
