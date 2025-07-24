{ inputs, lib, config, pkgs, ... }:
{
  home = {
    packages = (with pkgs; [
      gimp-with-plugins
      # gimpPlugins.gap
      gimpPlugins.gmic
      gimpPlugins.bimp
      gimpPlugins.resynthesizer
    ]);
    
    file = {
      splash = {
        enable = true;
        source = ./gimp-splash.png;
        target = ".config/GIMP/2.10/splashes/gimp-splash.png";
      };

      gimprc = {
        enable = true;
        source = ./gimprc;
        target = ".config/GIMP/2.10/gimprc";
      };

      menurc = {
        enable = true;
        source = ./menurc;
        target = ".config/GIMP/2.10/menurc";
      };

      toolrc = {
        enable = true;
        source = ./toolrc;
        target = ".config/GIMP/2.10/toolrc";
      };
    };
  };
}