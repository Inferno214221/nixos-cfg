{ config, pkgs, lib, ... }:
let
  location = (import ./location.nix) {};
in
{
  imports = [
    ./hosts/laptop
  ];

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  time.timeZone = location.timeZone;

  i18n = rec {
    defaultLocale = "en_AU.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "au";
        variant = "";
      };

      displayManager.lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;

          theme = {
            name = "Kali-Dark";
            package = import ../pkgs/kali-dark { inherit pkgs; };
          };

          iconTheme = {
            name = "Papirus-Dark";
            package = pkgs.papirus-icon-theme;
          };

          cursorTheme = {
            name = "Yaru-dark";
            package = pkgs.yaru-theme;
          };

          indicators = [
            "~host"
            "~spacer"
            "~clock"
            "~spacer"
            "~session"
            "~power"
          ];

          clock-format = "%a %d %b, %I:%M %p";

          extraConfig = ''
            font-name = Ubuntu 11
            default-user-image = ${../home/desktop/pictures/pfp.png}
          '';
        };
      };
      desktopManager.xfce.enable = true;

      excludePackages = [ pkgs.xterm ];
    };

    printing.enable = true;

    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    gvfs = {
      enable = true;
      package = pkgs.gnome.gvfs;
    };

    redshift = {
      enable = true;
      brightness = {
        # Note the string values below.
        day = "1";
        night = "1";
      };
      temperature = {
        day = 6500;
        night = 3800;
      };
    };

    blueman.enable = true;

    postgresql = {
      enable = true;
      package = pkgs.postgresql_15; 
    };
  };

  security = {
    doas = {
      enable = true;
      extraRules = [ {
        groups = [ "wheel" "plugdev" ];
        persist = true;
      } ];
    };

    rtkit.enable = true;
  };

  programs ={
    zsh.enable = true;

    nh = {
      enable = true;
      flake = "/home/inferno214221/config/";
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    adb.enable = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;

    users.inferno214221 = {
      isNormalUser = true;
      description = "Inferno214221";
      extraGroups = [ "networkmanager" "wheel" "docker" "plugdev" "adbusers" "postgres" "vboxusers" "dialout" ];
      packages = with pkgs; [];
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  environment = {
    # TODO: theme login screen by install kali-dark
    xfce.excludePackages = with pkgs.xfce; [
      mousepad
      parole
      ristretto
      xfce4-taskmanager
      xfce4-screenshooter
    ];

    systemPackages = (with pkgs; [
      pciutils
      lshw
      wget
      home-manager
      dos2unix
      glibc
      btrfs-progs
      gparted
      bluez
      distrobox
      exfat
      exfatprogs
    ]) ++ (with pkgs.xfce; [
      xfce4-mpc-plugin
      xfce4-systemload-plugin
      xfce4-genmon-plugin
      xfce4-whiskermenu-plugin
      xfce4-pulseaudio-plugin
      xfce4-docklike-plugin
    ]);

    sessionVariables = {
      DOAS_PROMPT = [ "\\x1b[42m  \\x1b[44m\\x1b[32m\\x1b[0m\\x1b[1m\\x1b[44m  [DOAS] Password \\x1b[0m\\x1b[34m\\x1b[0m " ];
      DOAS_AUTH_FAIL_MSG = [ "Authentication Failed" ];

      PGDATA = "/var/lib/postgresql/data";
    };
  };

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      ubuntu_font_family
      meslo-lgs-nf
    ];
  };

  hardware.keyboard = {
    qmk.enable = true;
    zsa.enable = true;
  };

  location = location.coords;

  virtualisation = {
    docker = {
      enable = true;
      # setSocketVariable = true;
    };

    podman = {
      enable = true;
      # dockerCompat = true;
    };

    virtualbox.host = {
      enable = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
