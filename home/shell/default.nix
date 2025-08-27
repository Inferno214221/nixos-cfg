{ inputs, lib, config, pkgs, ... }:
{
  imports = [
    ./zsh
  ];

  home = {
    packages = with pkgs; [
      curl
      tree
      killall
      units

      tldr
      fastfetch
      sd
      xh
      nix-tree
      hyperfine
      delta

      ffmpeg
      imagemagick

      yt-dlp
      mp3gain

      pdftk
      pandoc
      texlive.combined.scheme-small
      typst
    ];

    shellAliases = {
      # "snix" = "sudo nixos-rebuild switch --flake /home/inferno214221/config/#nixos";
      # "tnix" = "sudo nixos-rebuild test --flake /home/inferno214221/config/#nixos";
      # "hix" = "home-manager switch --flake \"/home/inferno214221/config/?submodules=1#inferno214221\"";
      "snix" = "nh os switch path:/home/inferno214221/config";
      "tnix" = "nh os test path:/home/inferno214221/config";
      "hix" = "nh home switch path:/home/inferno214221/config";
      "clix" = "nh clean all --nogcroots";
      "clax" = "nh clean all";
      "nup" = "nix flake update --flake path:/home/inferno214221/config";
      "nsh" = "nix-shell -p"; # --command zsh

      # I use aliases here so that I don't break my workflow if I switch environment.
      "sudo" = "doas";
      "su" = "su -c zsh";
      "cd" = "z";
      "ls" = "eza -l --no-user --no-time --sort=type --hyperlink";
      "ls-full" = "eza -l --time-style=relative --smart-group";
      "tree" = "eza -l --no-user --no-time --sort=type --total-size --git-ignore -T -L";
      "cat" = "bat";
      # "find" = "fd";
      "grep" = "rg";
      # "sed" = "sd";
      "delta" = "delta --file-style white --hunk-header-style omit";
      "fetch" = "fastfetch";
      # less
      # nano
      "reset-cmds" = "unalias sudo su cd ls tree cat grep fetch";

      "battery" = "echo \"$(cat /sys/class/power_supply/BAT1/capacity)%\"";
      "loc" = "git ls-files | grep -v -E \"^\\..*\" | grep -E \".*\\.(jsx?|tsx?|html|css?|cc?|java|sh|py|rs)\" | xargs wc -l";
      "yt-dlp-mp3" = "yt-dlp -x --audio-format mp3";
      "mp3gain-all" = "find . -type f -name \"*.mp3\" -exec mp3gain -r \{\} +";
      "edit-hist" = "gedit ~/.zsh_history";
      "units" = "units -1 --compact";
    };

    file = {
      personal-ssh-key = {
        enable = true;
        source = ./keys/github_personal;
        target = ".ssh/github_personal";
      };

      personal-ssh-key-pub = {
        enable = true;
        source = ./keys/github_personal.pub;
        target = ".ssh/github_personal.pub";
      };
    };

    activation.importGpgKey = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${pkgs.gnupg}/bin/gpg --batch --import "${./keys/github_personal_signing.asc}" || true
    '';
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
      lfs.enable = true;

      signing = {
        signByDefault = true;
        key = "0xBB5244EBF14A3C91";
      };
      
      extraConfig = {
        init.defaultBranch = "main";
        color.ui = true;
      };
    };

    ssh = {
      enable = true;
      
      extraConfig = ''
        Host github.com
          HostName github.com
          User git
          IdentityFile ~/.ssh/github_personal
          IdentitiesOnly yes
      '';
    };

    gpg.enable = true;

    zoxide = {
      enable = true;
      options = [ "--hook prompt" ];
      # TODO: Fix autocomplete
    };

    eza = {
      enable = true;
      git = true;
      colors = "always";
      icons = "always";
    };

    bat.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    # fzf.enable = true;
    nix-index.enable = true;
    # nix-index-database.comma.enable = true;
    nix-your-shell.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}