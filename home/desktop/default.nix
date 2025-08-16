{ inputs, lib, config, pkgs, ... }: let
  mkPkgGroup = import ../../util/pkg-group.nix { inherit pkgs lib; };
in {
  imports = [
    ./firefox
    ./gimp
    ./rofi
    ./screenshots
    ./vscodium
    ./xfce
  ];

  home = {
    packages = (with pkgs; [ # Current, Standard Packages
      nemo-with-extensions
      gitkraken
      shotwell
      xcape
      discord
      # sayonara
      # thunderbird
      vlc # TODO: qt5ct
      xmousepasteblock
      xorg.xmodmap
      xorg.xkill
      xcape
      galculator # TODO: stick window above
      corefonts
      vistafonts
      baobab
      youtube-music
      jetbrains.idea-community-src # TODO: configure theme, keybinds, extensions, etc...
      android-studio
      libreoffice # TODO: compact theme, papirus icons, keybinds
      chromium
      inkscape # TODO: switch to default theme, add as svg default
      pinta
      kdePackages.kdenlive # TODO: configure & theme
      obs-studio
      mine.timekeeper
      old-gnome.nautilus
      old-gnome.gedit
    ]) ++ (with pkgs.old.gnome; [ # Old Gnome Packages
      evince
      file-roller
      gnome-system-monitor
      gnome-disk-utility
    ]) ++ (with pkgs.unstable; [ # Unstable Packages
      # Placeholder
    # ]) ++ ([ # My Packages
    #   (pkgs.callPackage ./xfce/dynamic-workspaces.nix { inherit pkgs; })
    ]);

    file = {
      gitkraken-theme = {
        enable = true;
        source = ./gitkraken/kali-dark.jsonc;
        target = ".gitkraken/themes/kali-dark.jsonc";
      };

      pfp = {
        enable = true;
        source = ./pictures/pfp.png;
        target = ".face";
      };

      galculator-config = {
        enable = true;
        source = ./galculator/galculator.conf;
        target = ".config/galculator/galculator.conf";
        force = true;
      };

      # Autostart
      middle-click-paste-blocker = {
        enable = true;
        source = ./startup/middle-click-paste-blocker.desktop;
        target = ".config/autostart/middle-click-paste-blocker.desktop";
      };

      no-bell = {
        enable = true;
        source = ./startup/no-bell.desktop;
        target = ".config/autostart/no-bell.desktop";
      };

      xcape = {
        enable = true;
        source = ./startup/xcape.desktop;
        target = ".config/autostart/xcape.desktop";
      };

      xmodmap = {
        enable = true;
        text = ''
          [Desktop Entry]
          Name=xmodmap
          Exec=xmodmap ${./startup/.xmodmap}
        '';
        target = ".config/autostart/xmodmap.desktop";
      };
    };

    # sessionVariables = {};
    
    activation = {
      # This reverts the font size change that occurs on activation.
      fixFontSize = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run ${pkgs.xfce.xfconf}/bin/xfconf-query -c xsettings -p /Gtk/FontName -t string -s "Ubuntu 11"
      '';
    };
  };

  programs = {
    terminator = {
      enable = true;
      config = {
        global_config.suppress_multiple_term_dialog = true;
        keybindings = {
          new_tab = "<Primary>t";
          cycle_next = "<Primary><Shift>Tab";
          cycle_prev = "<Primary>asciitilde";
          split_horiz = "<Primary>slash";
          split_vert = "<Primary>backslash";
          close_term = "<Primary>w";
          next_tab = "<Primary>Tab";
          prev_tab = "<Primary>grave";
        };
        profiles.default = {
          background_darkness = 0.85;
          background_type = "transparent";
          font = "MesloLGS NF 11";
          show_titlebar = false;
          scrollback_infinite = true;
          palette = "#171421:#c01c28:#26a269:#a2734c:#12488b:#a347ba:#2aa1b3:#d0cfcc:#5e5c64:#f66151:#33da7a:#e9ad0c:#2a7bde:#c061cb:#33c7de:#ffffff";
          use_system_font = false;
          use_theme_colors = true;
        };
      };
    };
  };

  gtk = {
    enable = true;

    theme = {
      name = "Kali-Dark";
      package = import ../../pkgs/kali-dark { inherit pkgs; };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Yaru-dark";
      package = pkgs.yaru-theme;
    };

    font = {
      name = "Ubuntu";
      package = pkgs.ubuntu_font_family;
    };
  };

  xdg.desktopEntries = {
    launcher = {
      name = "Launcher";
      icon = "distributor-logo-nixos";
      exec = "rofi -show drun -drun-exclude-categories XFCE,X-XFCE,X-XFCE-SettingsDialog,X-NixPkgGroup";
      noDisplay = true;
    };

    # group-manager = {
    #   name = "Package Groups...";
    #   icon = "${../distributor-logo-nixos.svg}";
    #   exec = "rofi -show drun -drun-categories X-NixPkgGroup";
    #   # noDisplay = true;
    # };

    # TODO: move these to overlays

    # gimp = {
    #   name = "GIMP";
    #   icon = "gimp";
    #   exec = "gimp-2.10 %U";
    #   mimeType = [
    #     "image/bmp" "image/g3fax" "image/gif" "image/x-fits" "image/x-pcx" "image/x-portable-anymap" "image/x-portable-bitmap" "image/x-portable-graymap" "image/x-portable-pixmap" "image/x-psd" "image/x-sgi" "image/x-tga" "image/x-xbitmap" "image/x-xwindowdump" "image/x-xcf" "image/x-compressed-xcf" "image/x-gimp-gbr" "image/x-gimp-pat" "image/x-gimp-gih" "image/x-sun-raster" "image/tiff" "image/jpeg" "image/x-psp" "application/postscript" "image/png" "image/x-icon" "image/x-xpixmap" "image/x-exr" "image/webp" "image/x-webp" "image/heif" "image/heic" "image/avif" "image/jxl" "image/svg+xml" "application/pdf" "image/x-wmf" "image/jp2" "image/x-xcursor"
    #   ];
    # };

    idea-community = {
      name = "IntelliJ IDEA";
      icon = "idea-community";
      exec = "idea-community";
      settings.StartupWMClass = "jetbrains-idea-ce";
    };

    android-studio = {
      name = "Android Studio";
      icon = "android-studio";
      exec = "android-studio";
      settings.StartupWMClass = "jetbrains-studio";
    };
  };
}