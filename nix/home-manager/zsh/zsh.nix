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
    initContent = ''
      if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
        [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
      else
        [[ ! -f ${./p10k.tty.zsh} ]] || source ${./p10k.tty.zsh}
      fi
    '';
  };
}