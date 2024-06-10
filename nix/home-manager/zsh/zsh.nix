{ inputs, lib, config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    oh-my-zsh.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    # https://github.com/NixOS/nixpkgs/issues/154696
    # The powerlevel theme I'm using is distgusting in TTY, let's default
    # to something else
    # See https://github.com/romkatv/powerlevel10k/issues/325
    # Instead of sourcing this file you could also add another plugin as
    # this, and it will automatically load the file for us
    # (but this way it is not possible to conditionally load a file)
    # {
    #   name = "powerlevel10k-config";
    #   src = lib.cleanSource ./p10k-config;
    #   file = "p10k.zsh";
    # }
    initExtra = ''
      if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
        [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
      else
        [[ ! -f ${./p10k.tty.zsh} ]] || source ${./p10k.tty.zsh}
      fi
    '';
  };
}