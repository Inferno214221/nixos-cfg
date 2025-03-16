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
    rev = "409d0370395ed4bbbef93628944aca7ece094f7d";
    sha256 = "sha256-rT1beM+BWYh9MM93ctpF7h5WWgC4jXldyG5uclbURbM=";
  };

  dontDisableStatic = true;

  installPrefix = "share/vscode/extensions/inferno214221.kali-dark-vscode";

  installPhase = ''
    mkdir -p $out/share/vscode/extensions/inferno214221.kali-dark-vscode
    find . -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"
  '';
}