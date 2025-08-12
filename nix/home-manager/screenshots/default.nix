{ inputs, lib, config, pkgs, ... }:
{
  home = {
    packages = (with pkgs; [
      maim
      tesseract
      xclip
      (xcolor.overrideAttrs (old: {
        postFixup = ''
          rm $out/share/applications/*
        '';
      }))
      feh

      (pkgs.writeShellScriptBin "printscrn" ''
        FILENAME=$(date +%F_%H-%M-%S)
        maim -su ~/pictures/screenshots/screenshot-$FILENAME.png &&
        cat ~/pictures/screenshots/screenshot-$FILENAME.png |
        xclip -selection c -t image/png
      '')

      (pkgs.writeShellScriptBin "printscrn+ctrl" ''
        FILENAME=$(date +%F_%H-%M-%S)
        maim -u ~/pictures/screenshots/screenshot-$FILENAME.png &&
        cat ~/pictures/screenshots/screenshot-$FILENAME.png |
        xclip -selection c -t image/png
      '')

      (pkgs.writeShellScriptBin "printscrn+ctrl+shift" ''
        xcolor -f HEX |
        xclip -selection c
      '')

      (pkgs.writeShellScriptBin "printscrn+shift" ''
        maim -u |
        feh -x --no-xinerama -F - & id=$!
        FILENAME=$(date +%F_%H-%M-%S)
        maim -su ~/pictures/screenshots/screenshot-$FILENAME.png &&
        cat ~/pictures/screenshots/screenshot-$FILENAME.png |
        xclip -selection c -t image/png
        kill $id
      '')

      (pkgs.writeShellScriptBin "printscrn+super" ''
        maim -su |
        tesseract - - |
        xclip -selection c
      '')
    ]);
  };
}