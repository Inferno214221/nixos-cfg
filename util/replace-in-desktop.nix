{ pkgs }:
{
  pkg,
  desktopName,
  find,
  replace
}: pkgs.symlinkJoin rec {
  name = "desktop-tweaks-${pkg.name}";
  paths = [ pkg ];

  postBuild = ''
    rm $out/share/applications/${desktopName}.desktop
    cp ${pkg}/share/applications/${desktopName}.desktop $out/share/applications/${desktopName}.desktop
    sed -i -e "s/${find}/${replace}/g" $out/share/applications/${desktopName}.desktop
  '';
}