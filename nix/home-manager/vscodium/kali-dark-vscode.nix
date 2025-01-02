{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "inferno214221.kali-dark-vscode";
  vscodeExtUniqueId = "inferno214221.kali-dark-vscode";
  vscodeExtPublisher = "inferno214221";
  vscodeExtName = "kali-dark-vscode";
  version = "1.0.0";

  src = ./kali-dark-vscode;

  installPrefix = "share/vscode/extensions/inferno214221.kali-dark-vscode";

  installPhase = ''
    mkdir -p $out/share/vscode/extensions/inferno214221.kali-dark-vscode
    find . -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"
  '';
}