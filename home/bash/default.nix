{ ... }:
{
# Change the cursor into a barre for insert mode / bloc in normal mode
  programs.readline = {
    enable = true;
    includeSystemConfig = true;
    variables = {
      editing-mode = "vi";
      show-mode-in-prompt = true;
      vi-ins-mode-string = ''\1\e[6 q\2'';
      vi-cmd-mode-string = ''\1\e[2 q\2'';
    };
  };


  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      set -o vi
    '';
    initExtra = ''
      nitch
    '';
    shellAliases = { c = "clear"; };
  };
}

