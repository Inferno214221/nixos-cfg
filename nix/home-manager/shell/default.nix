{ inputs, lib, config, pkgs, ... }:
{
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
      "snix" = "nh os switch path:/home/inferno214221/config/nix";
      "tnix" = "nh os test path:/home/inferno214221/config/nix";
      "hix" = "nh home switch path:/home/inferno214221/config/nix";
      "clix" = "nh clean all --nogcroots";
      "clix-all" = "nh clean all";
      "nup" = "nix flake update --flake path:/home/inferno214221/config/nix";
      "nsh" = "nix-shell -p"; #  --command zsh

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
      "diff" = "delta --file-style white --hunk-header-style omit";
      "fetch" = "fastfetch";
      # less
      # nano
      "reset-cmds" = "unalias sudo su cd ls tree cat find grep sed diff fetch";

      "battery" = "echo \"$(cat /sys/class/power_supply/BAT1/capacity)%\"";
      "loc" = "git ls-files | grep -v -E \"^\\..*\" | grep -E \".*\\.(jsx?|tsx?|html|css?|cc?|java|sh|py|rs)\" | xargs wc -l";
      "yt-dlp-mp3" = "yt-dlp -x --audio-format mp3";
      "mp3gain-all" = "find . -type f -name \"*.mp3\" -exec mp3gain -r \{\} +";
      "edit-hist" = "gedit ~/.zsh_history";
      "units" = "units -1 --compact";
    };
  };

  programs = {
    bash = {
      enable = true;
      historyControl = [ "ignoredups" ];
    };

    zsh = {
      enable = true;
      oh-my-zsh.enable = true;
      syntaxHighlighting.enable = true;
      # autosuggestion.enable = true;

      plugins = [ {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      } ];

      # https://github.com/NixOS/nixpkgs/issues/154696
      initContent = ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "$HOME/.cache/p10k-instant-prompt-inferno214221.zsh" ]]; then
          source "$HOME/.cache/p10k-instant-prompt-inferno214221.zsh"
        fi

        if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
          [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
        else
          [[ ! -f ${./p10k.tty.zsh} ]] || source ${./p10k.tty.zsh}
        fi
      '';
    };

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
}