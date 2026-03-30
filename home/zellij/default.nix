{ ... }:
{
    programs.zellij = {
      enable = true;
      enableBashIntegration = true;
      attachExistingSession = true;
      settings.theme = "default";
    };
}
