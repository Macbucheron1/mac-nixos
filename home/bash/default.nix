{ pkgs, ... }:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    
    # For starship prompt
    #initExtra = ''eval "$(${pkgs.starship}/bin/starship init bash)"'';

    # To laucnh tmux automatically when opening a terminal
    #bashrcExtra = ''
    #  if [ -x "$(command -v tmux)" ] && [ -n "$DISPLAY" ] && [ -z "$TMUX" ]; then
    #      exec tmux new-session -A -s $USER >/dev/null 2>&1
    #  fi
    #'';
  };
}