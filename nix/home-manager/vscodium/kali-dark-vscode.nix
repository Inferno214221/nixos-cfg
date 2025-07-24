{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "inferno214221.kali-dark-vscode";
  vscodeExtUniqueId = "inferno214221.kali-dark-vscode";
  vscodeExtPublisher = "inferno214221";
  vscodeExtName = "kali-dark-vscode";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "inferno214221";
    repo = "kali-dark-vscode";
    rev = "095b3e9d3260f614021fb6fb4c3ab068219672d0";
    hash = "sha256-VU/HeS5s81/6vLdIj9zy+5xgOHwbFQ8fG2+mHloIgDg=";
  };

  dontDisableStatic = true;

  installPrefix = "share/vscode/extensions/inferno214221.kali-dark-vscode";

  installPhase = ''
    mkdir -p $out/$installPrefix
    find . -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"
  '';
}