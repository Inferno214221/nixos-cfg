final: prev: let
  replaceInDesktop = import ../util/replace-in-desktop.nix { pkgs = prev; };
in {
  blueman = replaceInDesktop {
    pkg = prev.blueman;
    desktopName = "blueman-manager";
    find = "Categories=";
    replace = "Categories=X-XFCE;X-XFCE-SettingsDialog;";
  };
  redshift = prev.redshift.overrideAttrs (oldAttrs: {
    postInstall = ''
      echo "NoDisplay=true" >> $out/share/applications/redshift.desktop
    '';
  });
  vscodium = prev.vscodium.overrideAttrs (oldAttrs: {
    postFixup = oldAttrs.postFixup + ''
      sed -i -e "s/Name=VSCodium - URL Handler/Name=VSCodium/g" $out/share/applications/codium-url-handler.desktop
    '';
  });
  gimp-with-plugins = replaceInDesktop {
    pkg = prev.gimp-with-plugins;
    desktopName = "gimp";
    find = "Name=GNU Image Manipulation Program";
    replace = "Name=GIMP";
  };
  gitkraken = replaceInDesktop {
    pkg = prev.gitkraken;
    desktopName = "GitKraken\\ Desktop";
    find = "Name=GitKraken Desktop";
    replace = "Name=GitKraken";
  };
}