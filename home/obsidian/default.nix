{ ... }:
{
  programs.obsidian = {
    enable = true;
    defaultSettings.communityPlugins = "excalidraw";  
  };

  xdg.configFile."obsidian/obsidian.json".enable = false;
}