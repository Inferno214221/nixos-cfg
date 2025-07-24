{ pkgs, ... }:
pkgs.stdenv.mkDerivation {
  name = "kali-dark";

  src = pkgs.fetchurl {
    url = "https://gitlab.com/kalilinux/packages/kali-themes/-/archive/kali/2024.2.1/kali-themes-kali-2024.2.1.tar.gz";
    hash = "sha256-GKXqjIEjeP/+q0yGL9NFOAYELLvvFbZubxI7gn1ea2M=";
  };

  patchPhase = ''
    # Remove dragon from large window titlebars.
    cp -f ${./kali-headerbar-logo.png} ./share/themes/Kali-Dark/gtk-3.0/assets/kali-headerbar-logo.png
    cp -f ${./kali-headerbar-logo-2.png} ./share/themes/Kali-Dark/gtk-3.0/assets/kali-headerbar-logo@2.png
    cp -f ${./kali-headerbar-logo.png} ./share/themes/Kali-Dark/gtk-3.0/assets/kali-headerbar-logo-dark.png
    cp -f ${./kali-headerbar-logo-2.png} ./share/themes/Kali-Dark/gtk-3.0/assets/kali-headerbar-logo-dark@2.png
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share

    # Standard theme files.
    cp -r ./share/themes $out/share/themes

    # Extra theme files including Gedit.
    cp -r ./share/gtksourceview-3.0 $out/share/gtksourceview-3.0
    cp -r ./share/gtksourceview-4 $out/share/gtksourceview-4
    cp -r ./share/gtksourceview-5 $out/share/gtksourceview-5

    # Not used atm, but should be helpful for qt programs.
    cp -r ./share/qt5ct $out/share/qt5ct
    cp -r ./share/qt6ct $out/share/qt6ct
  '';
}
