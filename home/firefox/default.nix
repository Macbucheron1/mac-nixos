{ inputs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.mac = {
      isDefault = true;

      bookmarks = {
        force = true;
        settings = [
          {
            toolbar = true;  # ce dossier spécial représente la barre
            bookmarks = [
              {
                name = "Home Manager Search";
                url  = "https://home-manager-options.extranix.com/?query=&release=master";
              }
              {
                name = "ChatGPT";
                url = "https://chatgpt.com/?model=gpt-5-instant";
              }
              {
                name = "Github";
                url = "https://github.com/Macbucheron1";
              }
              {
                name = "Packages Search";
                url = "https://search.nixos.org/packages";
              }
            ];
          }
        ];
      };
    };
  };
}