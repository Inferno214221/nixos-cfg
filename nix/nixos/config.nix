# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  secrets = (import ../secrets.nix) {};
in
{
  imports = [
    ./hardware.nix
  ];

  networking = {
    hostName = "nixos";
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    networkmanager.enable = true;
  };

  time = {
    timeZone = "Australia/Adelaide";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "en_AU.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "au";
      variant = "";
    };

    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  
  security.doas = {
    enable = true;
    extraRules = [
      { groups = [ "wheel" "plugdev" ]; persist = true; }
    ];
  };

  environment.sessionVariables = {
    DOAS_PROMPT = [ "\\x1b[42m  \\x1b[44m\\x1b[32m\\x1b[0m\\x1b[1m\\x1b[44m  [DOAS] Password \\x1b[0m\\x1b[34m\\x1b[0m " ];
    DOAS_AUTH_FAIL_MSG = [ "Authentication Failed" ];
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs ={
    zsh.enable = true;

    nh = {
      enable = true;
      flake = "/home/inferno214221/config/";
    };

    direnv.enable = true;

    adb.enable = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;

    users.inferno214221 = {
      isNormalUser = true;
      description = "Inferno214221";
      extraGroups = [ "networkmanager" "wheel" "docker" "plugdev" "adbusers" ];
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
    # TODO: tweak kali-dark
    xfce.excludePackages = with pkgs.xfce; [
      mousepad
      parole
      ristretto
      xfce4-taskmanager
    ];

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = (with pkgs; [
      pciutils
      lshw
      wget
      tldr
      tree
      home-manager
      fastfetch
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

  location = secrets.location;

  services.redshift = {
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

  services.blueman.enable = true;

  virtualisation.podman = {
    enable = true;
    # dockerCompat = true;
  };

  virtualisation.docker = {
    enable = true;
    # setSocketVariable = true;
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
