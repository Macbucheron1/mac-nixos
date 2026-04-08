{ ... }:
{
  programs.burp = {
    enable = true;
    cliArgs = [
      "--disable-auto-update"
      "--unpause-spider-and-scanner"
    ];
    settings = {
        display.user_interface = {
        # Enable Darkmode
        look_and_feel = "Dark";
        # Change Scaling
        font_size = 17;
      };
    };
    extensions = {
      "json-web-tokens".enable = true;
      "mcp-server".enable = true;
    };
  };
}
