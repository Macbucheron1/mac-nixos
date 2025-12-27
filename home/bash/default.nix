{ ... }:
{
	programs.bash = {
		enable = true;
		enableCompletion = true;
		bashrcExtra = ''
		  set -o vi
		'';
    initExtra = ''
      nitch
    '';
    shellAliases = {
      c = "clear";
    };
	};
}
