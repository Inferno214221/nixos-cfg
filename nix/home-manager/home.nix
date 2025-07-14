{ inputs, lib, config, pkgs, ... }: let
  mkPkgGroup = import ../util/pkg-group.nix { inherit pkgs lib; };
in {
  imports = [
    ./firefox/firefox.nix
    ./gimp/gimp.nix
    ./rofi/rofi.nix
    ./screenshots/screenshots.nix
    ./vscodium/vscodium.nix
    ./xfce/xfce.nix
    ./zsh/zsh.nix
    ./work/work.nix
  ];

  # TODO: Rename heaps of desktop entires:
  # gedit -> Gedit
  # Firefox ESR -> Firefox
  # GNU Image Manipulation Program -> GIMP
  # VSCodium - URL Handler -> VSCodium
  # GitKraken Desktop -> GitKraken

  home = {
    username = "inferno214221";
    homeDirectory = "/home/inferno214221/";

    packages = (with pkgs; [ # Current, Standard Packages
      # TODO: Fix Gedit theme
      (gedit.overrideAttrs (old: let
          program = "gedit";
          desktopEntry = pkgs.makeDesktopItem {
            desktopName = "Gedit";
            name = program;
            icon = program;
            exec = "${program} %U";
            mimeTypes = [
              "text/plain" "application/x-zerosize"
            ];
            actions = {
              new-window = {
                name = "New Window";
                exec = "${program} --new-window";
              };
              new-document = {
                name = "New Document";
                exec = "${program} --new-document";
              };
            };
          };
        in {
        postInstall = ''
          rm $out/share/applications/*
          ln -s ${desktopEntry}/share/applications/${program}.desktop $out/share/applications/${program}.desktop
        '';
      }))
      nemo-with-extensions
      gitkraken
      shotwell
      xcape
      discord
      # # sayonara
      # # thunderbird
      curl
      # betterdiscordctl
      vlc # TODO: qt5ct
      xmousepasteblock
      xorg.xmodmap
      xorg.xkill
      xcape
      galculator # TODO: stick window above
      pandoc
      texlive.combined.scheme-small
      typst
      corefonts
      vistafonts
      # chromium
      yt-dlp
      mp3gain
      pdftk
      # android-studio
      baobab
      ffmpeg
      imagemagick
      nix-tree
      youtube-music
      units
      jetbrains.idea-community-src # TODO: configure theme, keybinds, extensions, etc...
      android-studio
      libreoffice # TODO: compact theme, papirus icons, keybinds
      chromium
      inkscape # TODO: switch to default theme, add as svg default
      pinta
      kdePackages.kdenlive # TODO: configure & theme
      obs-studio
      mine.timekeeper
    ]) ++ (with pkgs.old.gnome; [ # Old Gnome Packages
      (nautilus.overrideAttrs (prev: let
          program = "org.gnome.Nautilus";
          desktopEntry = pkgs.makeDesktopItem {
            desktopName = "Nautilus";
            name = program;
            icon = "nautilus";
            exec = "nautilus --new-window %U";
            mimeTypes = [
              "inode/directory" "application/x-7z-compressed" "application/x-7z-compressed-tar" "application/x-bzip" "application/x-bzip-compressed-tar" "application/x-compress" "application/x-compressed-tar" "application/x-cpio" "application/x-gzip" "application/x-lha" "application/x-lzip" "application/x-lzip-compressed-tar" "application/x-lzma" "application/x-lzma-compressed-tar" "application/x-tar" "application/x-tarz" "application/x-xar" "application/x-xz" "application/x-xz-compressed-tar" "application/zip" "application/gzip" "application/bzip2" "application/vnd.rar"
            ];
            actions = {
              new-window = {
                name = "New Window";
                exec = "nautilus --new-window";
              };
            };
          };
        in {
          preFixup = ''
            gappsWrapperArgs+=(
              # Add old version to GIO_EXTRA_MODULES to fix access to trash:// and other gvfs.
              --prefix GIO_EXTRA_MODULES : "${pkgs.old.gnome.gvfs}/lib/gio/modules"

              # Thumbnailers (Copied from 22.05 nautilus derivation).
              --prefix XDG_DATA_DIRS : "${pkgs.old.gdk-pixbuf}/share"
              --prefix XDG_DATA_DIRS : "${pkgs.old.librsvg}/share"

              # Use new version to fix crash when encountering *.mjs files.
              --prefix XDG_DATA_DIRS : "${pkgs.shared-mime-info}/share"
            )
          '';
          
          postInstall = ''
            rm $out/share/applications/*
            ln -s ${desktopEntry}/share/applications/${program}.desktop $out/share/applications/${program}.desktop
          '';
      }))
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

      better-discord-config = {
        enable = true;
        source = ./better-discord/config;
        target = ".config/BetterDiscord";
        recursive = true;
        force = true;
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
        # source = ./startup/xmodmap.desktop;
        text = ''
          [Desktop Entry]
          Name=xmodmap
          Exec=xmodmap ${./startup/.xmodmap}
        '';
        target = ".config/autostart/xmodmap.desktop";
      };
    };

    shellAliases = {
      # "snix" = "sudo nixos-rebuild switch --flake /home/inferno214221/config/#nixos";
      # "tnix" = "sudo nixos-rebuild test --flake /home/inferno214221/config/#nixos";
      # "hix" = "home-manager switch --flake \"/home/inferno214221/config/?submodules=1#inferno214221\"";
      "snix" = "nh os switch path:/home/inferno214221/config/nix";
      "tnix" = "nh os test path:/home/inferno214221/config/nix";
      "hix" = "nh home switch path:/home/inferno214221/config/nix";
      "clix" = "nh clean all --nogcroots";
      "nup" = "nix flake update --flake path:/home/inferno214221/config/nix";

      "ll" = "ls -l";
      "la" = "ls -a";
      "bat" = "echo \"$(cat /sys/class/power_supply/BAT1/capacity)%\"";
      "sudo" = "doas";
      "loc" = "git ls-files | grep -v -E \"^\\..*\" | grep -E \".*\\.(jsx?|tsx?|html|css?|cc?|java|sh|py|rs)\" | xargs wc -l";
      "yt-dlp-mp3" = "yt-dlp -x --audio-format mp3";
      "mp3gain-all" = "find . -type f -name \"*.mp3\" -exec mp3gain -r \{\} +";
      "edit-hist" = "gedit ~/.zsh_history";
      "units" = "units -1 --compact";
    };

    # sessionVariables = {
    # };

    # activation = {
    #   # PATH="${config.home.path}/bin:$PATH" $DRY_RUN_CMD betterdiscordctl install
    #   install-better-discord = lib.hm.dag.entryAfter ["installPackages"] ''
    #     d_core="$HOME/.config/discord/${pkgs.discord.version}/modules/discord_desktop_core"
    #     bd_asar="$HOME/.config/BetterDiscord/data/betterdiscord.asar"
    #     grep -Fq "$bd_asar" "$d_core/index.js" && die 'Better Discord already installed.'
    #     # "$bd_asar" > "$d_core/index.js"
    #   '';
    # };
    activation = {
      # This reverts the font size change that occurs on activation.
      fixFontSize = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run ${pkgs.xfce.xfconf}/bin/xfconf-query -c xsettings -p /Gtk/FontName -t string -s "Ubuntu 11"
      '';
    };
  };

  programs = {
    bash = {
      enable = true;
      historyControl = [ "ignoredups" ];
    };

    git = {
      enable = true;
      userName = "Inferno214221";
      userEmail = "inferno214221@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };

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
      package = import ./kali-dark/kali-dark-theme.nix { inherit pkgs; };
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

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}desktop";
      documents = "${config.home.homeDirectory}documents";
      download = "${config.home.homeDirectory}downloads";
      music = "${config.home.homeDirectory}music";
      pictures = "${config.home.homeDirectory}pictures";
      templates = "${config.home.homeDirectory}templates";
      videos = "${config.home.homeDirectory}videos";
      # Effectively Disabled:
      publicShare = "${config.home.homeDirectory}";
    };

    desktopEntries = {
      launcher = {
        name = "Launcher";
        icon = "${../distributor-logo-nixos.svg}";
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
  };

  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}