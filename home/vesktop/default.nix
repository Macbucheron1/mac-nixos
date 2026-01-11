
{ config, ... }:
let
  # Couleurs Stylix au format "#RRGGBB"
  c = config.lib.stylix.colors.withHashtag;

  # Police monospace Stylix (optionnel, mais cohérent avec system24)
  mono = config.stylix.fonts.monospace.name;
in
{
  stylix.targets.vesktop.enable = false;
  programs.vesktop = {
    enable = true;

    vencord = {
      # Active le moteur de thème Vencord + sélectionne le thème
      settings = {
        useQuickCss = true;
        enabledThemes = [ "system24-stylix.theme.css" ];
      };

      # Dépose un fichier dans le dossier "themes" de Vencord
      themes."system24-stylix.theme.css" = ''
        /**
         * @name system24 (Stylix)
         * @description system24 layout, colors driven by Stylix (base16)
         * @author refact0r + Nix/Stylix glue
         */

        /* Charge le CSS upstream */
        @import url("https://refact0r.github.io/system24/build/system24.css");

        /* ===== Options system24 =====
           (reprend le principe “on/off” et quelques valeurs texte)
        */
        body {
          --font: "${mono}";
          --code-font: "${mono}";

          --small-user-panel: on;      /* on/off */
          --unrounding: on;            /* on/off */
          --custom-spotify-bar: on;    /* on/off */
          --ascii-titles: on;          /* on/off */
          --ascii-loader: system24;    /* off | system24 | cats */
          --panel-labels: on;          /* on/off */
          --label-font-weight: 500;
        }

        /* ===== Couleurs: UNIQUEMENT Stylix =====
           Mapping base16 -> variables attendues par system24.
        */
        :root {
          --colors: on;

          /* backgrounds */
          --bg-4: ${c.base00}; /* main background */
          --bg-3: ${c.base01}; /* secondary background */
          --bg-2: ${c.base02}; /* buttons */
          --bg-1: ${c.base03}; /* clicked buttons */

          /* text */
          --text-5: ${c.base03}; /* muted */
          --text-4: ${c.base04}; /* channels/icons */
          --text-3: ${c.base05}; /* normal */
          --text-2: ${c.base06}; /* headings/important */
          --text-1: ${c.base07}; /* bright */
          --text-0: var(--bg-4); /* text on colored elements */

          /* states */
          --hover:    color-mix(in srgb, var(--text-3), transparent 90%);
          --active:   color-mix(in srgb, var(--text-3), transparent 82%);
          --active-2: color-mix(in srgb, var(--text-3), transparent 74%);
          --message-hover: color-mix(in srgb, var(--bg-4), white 4%);

          /* accent family (derive from base0D) */
          --lavender-1: ${c.base0D};
          --lavender-2: color-mix(in srgb, ${c.base0D}, white 12%);
          --lavender-3: color-mix(in srgb, ${c.base0D}, black 6%);
          --lavender-4: color-mix(in srgb, ${c.base0D}, white 20%);
          --lavender-5: color-mix(in srgb, ${c.base0D}, black 14%);

          --accent-1: var(--lavender-1);
          --accent-2: var(--lavender-2);
          --accent-3: var(--lavender-3);
          --accent-4: var(--lavender-4);
          --accent-5: var(--lavender-5);

          /* “danger” accent (mute/deafen etc.) */
          --accent-new: ${c.base08};

          /* mention / reply overlays (reprend l’approche system24) */
          --mention:       linear-gradient(to right, color-mix(in hsl, var(--accent-2), transparent 90%) 40%, transparent);
          --mention-hover: linear-gradient(to right, color-mix(in hsl, var(--accent-2), transparent 95%) 40%, transparent);
          --reply:         linear-gradient(to right, color-mix(in hsl, var(--text-3), transparent 90%) 40%, transparent);
          --reply-hover:   linear-gradient(to right, color-mix(in hsl, var(--text-3), transparent 95%) 40%, transparent);

          /* status indicators */
          --online:    ${c.base0B};
          --dnd:       ${c.base08};
          --idle:      ${c.base0A};
          --streaming: ${c.base0E};
          --offline:   var(--text-4);

          /* borders */
          --border-light: var(--hover);
          --border:       var(--active);
          --border-hover: var(--accent-2);
          --button-border: color-mix(in srgb, var(--text-1), transparent 90%);

          /* (optionnel) variables “-2” si certains bouts de CSS les utilisent */
          --red-2:    ${c.base08};
          --green-2:  ${c.base0B};
          --yellow-2: ${c.base0A};
          --blue-2:   ${c.base0C};
          --purple-2: ${c.base0E};
        }
      '';
    };
  };
}

