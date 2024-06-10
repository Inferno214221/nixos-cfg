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
      click-to-exit = false;
      kb-move-char-back = "Control+b";
      kb-move-char-forward = "Control+f";
      kb-row-left = "Left,Control+Page_Up";
      kb-row-right = "Right,Control+Page_Down";
      kb-row-select = "";
      kb-cancel = "Control+space,Escape,Control+Shift+Alt+Super+space";/*,Super*/
    };
  };
}