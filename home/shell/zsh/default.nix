{ inputs, lib, config, pkgs, ... }: let 
  patchedP10k = "${pkgs.stdenv.mkDerivation {
    name = "p10k-cfg-tty";
    version = "0.0.1";
    src = ./p10k;
    patches = [ ./p10k/tty.patch ];
    phases = [ "unpackPhase" "patchPhase" "buildPhase" ];
    buildPhase = ''
      mkdir -p $out/share
      cp p10k.zsh $out/share/p10k.tty.zsh
    '';
  }}/share/p10k.tty.zsh";
in {
  programs.zsh = {
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
        [[ ! -f ${./p10k/p10k.zsh} ]] || source ${./p10k/p10k.zsh}
      else
        [[ ! -f ${patchedP10k} ]] || source ${patchedP10k}
      fi
    '';
  };
}