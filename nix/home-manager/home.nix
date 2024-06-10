{ inputs, lib, config, pkgs, ... }:
{
  imports = [
    ./firefox/firefox.nix
    ./gimp/gimp.nix
    ./rofi/rofi.nix
    ./xfce/xfce.nix
    ./zsh/zsh.nix
  ];

  home = {
    username = "inferno214221";
    homeDirectory = "/home/inferno214221/";

    packages = (with pkgs; [
      gedit
      old.gnome.nautilus
      old.gnome.evince
      cinnamon.nemo-with-extensions
      gitkraken
      shotwell
      xcape
      gnome.gnome-system-monitor
      discord
      cinny-desktop
      sayonara
      thunderbird
      curl
      betterdiscordctl
      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
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

      # better-discord-config = {
      #   enable = true;
      #   source = ./better-discord;
      #   target = ".config/BetterDiscord";
      #   recursive = true;
      # };
    };

    shellAliases = {
      # "snix" = "sudo nixos-rebuild switch --flake /home/inferno214221/config/#nixos";
      # "tnix" = "sudo nixos-rebuild test --flake /home/inferno214221/config/#nixos";
      # "hix" = "home-manager switch --flake \"/home/inferno214221/config/?submodules=1#inferno214221\"";
      "snix" = "nh os switch path:/home/inferno214221/config/nix";
      "tnix" = "nh os test path:/home/inferno214221/config/nix";
      "hix" = "nh home switch path:/home/inferno214221/config/nix";
      "ll" = "ls -l";
      "la" = "ls -a";
      "bat" = "echo \"$(cat /sys/class/power_supply/BAT1/capacity)%\"";
      # "sudo" = "doas"; TODO
      "last-grass" = "history -E | grep \"touch grass\"";
      "loc" = "git ls-files | grep -v -E \"^\..*\" | grep -E \".*\.(jsx?|tsx?|html|css|cc?|java|cs|sh|py|rs)\" | xargs wc -l";
      # "yt-dlp-mp3" = "yt-dlp -x --audio-format mp3"; TODO
      # "mp3gain-all" = "find . -type f -name \"*.mp3\" -exec mp3gain -r \{\} +"; TODO
      # "edit-hist" = "gedit ~/.zsh_plain/history"; TODO
    };

    # sessionVariables = {
    # };

    # activation = {
    #   install-better-discrod = lib.hm.dag.entryAfter ["installPackages"] ''
    #     PATH="${config.home.path}/bin:$PATH" $DRY_RUN_CMD betterdiscordctl install
    #   '';
    # };
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

    vscode = {
      enable = true;
      package = pkgs.vscodium;
      # userSettings = {};
      # keybindings = [];
      mutableExtensionsDir = false;
      extensions = (with pkgs.open-vsx; [
        streetsidesoftware.code-spell-checker-australian-english
        edwinhuish.better-comments-next
        bungcip.better-toml
        uloco.theme-bluloco-dark
        alefragnani.bookmarks
        antfu.browse-lite
        streetsidesoftware.code-spell-checker
        vadimcn.vscode-lldb
        moshfeu.diff-merge
        usernamehw.errorlens
        dbaeumer.vscode-eslint
        eamodio.gitlens # To Modify
        # GML Support
        # Kali-Dark Theme
        fwcd.kotlin
        james-yu.latex-workshop
        ms-vscode.live-server
        domdomegg.markdown-inline-preview-vscode # To Modify
        jnoortheen.nix-ide
        jeanp413.open-remote-ssh
        # Pseudocode
        rust-lang.rust-analyzer
        gruntfuggly.todo-tree
        vscode-icons-team.vscode-icons
        dotjoshjohnson.xml
      ]) ++ (with pkgs.vscode-marketplace; [
        redhat.java
        ms-python.python
        redhat.vscode-xml
      ]);
    };
  };

  gtk = {
    enable = true;

    theme = {
      name = "Kali-Dark";
      package = import ../pkgs/kali-dark-theme.nix { inherit pkgs; };
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
        exec = "sleep 10";
      };

      "org.gnome.Nautilus" = {
        name = "Nautilus";
        icon = "nautilus";
        exec = "nautilus --new-window %U";
        comment = "Access and organize files";
        mimeType = [
          "inode/directory" "application/x-7z-compressed" "application/x-7z-compressed-tar" "application/x-bzip" "application/x-bzip-compressed-tar" "application/x-compress" "application/x-compressed-tar" "application/x-cpio" "application/x-gzip" "application/x-lha" "application/x-lzip" "application/x-lzip-compressed-tar" "application/x-lzma" "application/x-lzma-compressed-tar" "application/x-tar" "application/x-tarz" "application/x-xar" "application/x-xz" "application/x-xz-compressed-tar" "application/zip" "application/gzip" "application/bzip2" "application/vnd.rar"
        ];
        actions = {
          new-window = {
            name = "New Window";
            exec = "nautilus --new-window";
          };
        };
      };

      "org.gnome.gedit" = {
        name = "Gedit";
        icon = "org.gnome.gedit";
        exec = "gedit %U";
        comment = "Edit text files";
        mimeType = [
          "text/plain" "application/x-zerosize"
        ];
        actions = {
          new-window = {
            name = "New Window";
            exec = "gedit --new-window";
          };
          new-document = {
            name = "New Document";
            exec = "gedit --new-document";
          };
        };
      };

      gimp = {
        name = "GIMP";
        icon = "gimp";
        exec = "gimp-2.10 %U";
        comment = "Create images and edit photographs";
        mimeType = [
          "image/bmp" "image/g3fax" "image/gif" "image/x-fits" "image/x-pcx" "image/x-portable-anymap" "image/x-portable-bitmap" "image/x-portable-graymap" "image/x-portable-pixmap" "image/x-psd" "image/x-sgi" "image/x-tga" "image/x-xbitmap" "image/x-xwindowdump" "image/x-xcf" "image/x-compressed-xcf" "image/x-gimp-gbr" "image/x-gimp-pat" "image/x-gimp-gih" "image/x-sun-raster" "image/tiff" "image/jpeg" "image/x-psp" "application/postscript" "image/png" "image/x-icon" "image/x-xpixmap" "image/x-exr" "image/webp" "image/x-webp" "image/heif" "image/heic" "image/avif" "image/jxl" "image/svg+xml" "application/pdf" "image/x-wmf" "image/jp2" "image/x-xcursor"
        ];
      };

      install-better-discord = {
        name = "Install BD";
        icon = "discord";
        exec = "betterdiscordctl reinstall";
        comment = "(Re)installs better discord";
      };
    };
  };

  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
