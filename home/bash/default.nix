{ pkgs, config, ... }:
let 
  fzfTab = pkgs.nur.repos.hexadecimalDinosaur.fzf-tab-completion;
in
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

      # --- PS1 stylé, couleurs depuis Stylix ---
      # On récupère les couleurs Stylix (hex avec '#')
      _sx_icon="${config.lib.stylix.colors.withHashtag.base0D}"
      _sx_user="${config.lib.stylix.colors.withHashtag.base0B}"
      _sx_path="${config.lib.stylix.colors.withHashtag.base0C}"
      _sx_hex_to_rgb() {
        local hex="''${1#\#}"
        printf "%d;%d;%d" \
          $((16#''${hex:0:2})) \
          $((16#''${hex:2:2})) \
          $((16#''${hex:4:2}))
      }
      _sx_fg() {
        printf '\[\e[38;2;%sm\]' "$(_sx_hex_to_rgb "$1")"
      }
      _sx_reset='\[\e[0m\]'
      _sx_bold='\[\e[1m\]'
      _c_icon="$(_sx_fg "$_sx_icon")"
      _c_user="$(_sx_fg "$_sx_user")"
      _c_path="$(_sx_fg "$_sx_path")"
      export PS1="\n''${_c_icon} ''${_sx_reset} ''${_sx_bold}''${_c_user}\u ''${_c_path}\w''${_sx_reset} ''${_sx_bold}\$''${_sx_reset} "
      # --- PS1 ---

      source ${fzfTab}/bash/fzf-bash-completion.sh
      bind -x '"\t": fzf_bash_completion'
    '';

    initExtra = ''
      ${pkgs.nitch}/bin/nitch
    '';

    shellAliases = { 
      c = "clear"; 
      l = "${pkgs.eza}/bin/eza -lah --git --icons=always"; 
      ll = "${pkgs.eza}/bin/eza -lah --git --icons=always";
      ls = "${pkgs.eza}/bin/eza -G --icons";
      tree = "${pkgs.eza}/bin/eza -T --icons";
    };
  };
}

