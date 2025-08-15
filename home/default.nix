{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./desktop
    ./shell
    ./work
  ];

  home = {
    username = "inferno214221";
    homeDirectory = "/home/inferno214221";
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/desktop";
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      templates = "${config.home.homeDirectory}/templates";
      videos = "${config.home.homeDirectory}/videos";
      # Effectively Disabled:
      publicShare = "${config.home.homeDirectory}";
    };
  };

  systemd.user.startServices = "sd-switch";

  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}