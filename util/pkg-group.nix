{ pkgs, lib }:
{
  name,
  icon ? null,
  packages,
  priority ? 4
} @ options: let
  sanitizedName = lib.strings.sanitizeDerivationName (lib.strings.toLower options.name);
  pkgGroupPathName = "${sanitizedName}-pkg-group-path";
  activateName = "activate-${sanitizedName}";

  pkgGroupPath = pkgs.symlinkJoin {
    name = pkgGroupPathName;
    paths = options.packages;
  };

  activationScript = pkgs.writeShellApplication {
    name = activateName;
    runtimeInputs = with pkgs; [ nix jq ];
    text = ''
      if
        nix profile list --json |
        jq '.["elements"].["${pkgGroupPathName}"]' -e > /dev/null;
      then
        nix profile remove ${pkgGroupPath} > /dev/null 2>&1 ||
        echo "Failed to remove group!"
      else
        nix profile install ${pkgGroupPath} --priority ${toString priority} > /dev/null 2>&1 ||
        echo "Failed to add group!"
      fi
    '';
  };
in pkgs.symlinkJoin {
  name = "${sanitizedName}-pkg-group-activation";
  paths = [
    activationScript
    (pkgs.makeDesktopItem {
      # TODO: optional hide
      name = activateName;
      desktopName = "Activate '${options.name}'";
      # TODO: not optional
      icon = icon;
      exec = "${activationScript}/bin/${activateName} %f";
      categories = [ "X-NixPkgGroup" ];
    })
  ];
}