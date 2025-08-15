{ inputs, lib, config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    theme = ./kali-dark.rasi;
    extraConfig = {
      drun-match-fields = "name";
      drun-display-format = "{name}";
      disable-history = false;
      hover-select = true;
      click-to-exit = true;
      kb-move-char-back = "Control+b";
      kb-move-char-forward = "Control+f";
      kb-row-left = "Left,Control+Page_Up";
      kb-row-right = "Right,Control+Page_Down";
      kb-row-select = "";
      kb-cancel = "Control+space,Escape,Control+Shift+Alt+Super+space";/*,Super*/
    };
    package = pkgs.unstable.rofi-unwrapped.overrideAttrs (old: rec {
      # Use development version which supports '-drun-exclude-categories' flag.
      src = pkgs.fetchFromGitHub {
        owner = "davatorium";
        repo = "rofi";
        rev = "0187d838946301e36dfadb7c6c000f68d1aec6de";
        fetchSubmodules = true;
        hash = "sha256-VtG9B1YOHRsiNKO4ysAWMIpEDWaA5H2fk79WWE315RI=";
      };
      postInstall = ''
        rm $out/share/applications/*
      '';
    });
  };
}