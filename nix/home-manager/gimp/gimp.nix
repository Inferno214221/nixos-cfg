{ inputs, lib, config, pkgs, ... }:
{
  home = {
    packages = (with pkgs; [
      gimp-with-plugins
      gimpPlugins.gap
      gimpPlugins.gmic
      gimpPlugins.bimp
      # gimpPlugins.resynthesizer
    ]) ++ (with pkgs.unstable; [
      # (gimp3.overrideAttrs (old: let
      #     desktopEntry = pkgs.makeDesktopItem {
      #       desktopName = "GIMP 3";
      #       name = "gimp3";
      #       icon = "gimp";
      #       exec = "gimp-3 %U";
      #       mimeTypes = [
      #         "image/bmp" "image/g3fax" "image/gif" "image/x-fits" "image/x-pcx" "image/x-portable-anymap" "image/x-portable-bitmap" "image/x-portable-graymap" "image/x-portable-pixmap" "image/x-psd" "image/x-sgi" "image/x-tga" "image/x-xbitmap" "image/x-xwindowdump" "image/x-xcf" "image/x-compressed-xcf" "image/x-gimp-gbr" "image/x-gimp-pat" "image/x-gimp-gih" "image/x-sun-raster" "image/tiff" "image/jpeg" "image/x-psp" "application/postscript" "image/png" "image/x-icon" "image/x-xpixmap" "image/x-exr" "image/webp" "image/x-webp" "image/heif" "image/heic" "image/avif" "image/jxl" "image/svg+xml" "application/pdf" "image/x-wmf" "image/jp2" "image/x-xcursor"
      #       ];
      #     };
      #   in {
      #   postInstall = ''
      #     rm $out/share/applications/*
      #     ln -s ${desktopEntry}/share/applications/gimp3.desktop $out/share/applications/gimp3.desktop
      #   '';
      # }))
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