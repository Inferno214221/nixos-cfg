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
    rev = "12fe4de59c127d109be0fc438694cea5bdc0d4c6";
    sha256 = "sha256-KVsZR/eaHc5aXmZJF/WxRAV7g02gl3RDwTrwSjVVQSM=";
  };

  dontDisableStatic = true;

  installPrefix = "share/vscode/extensions/inferno214221.kali-dark-vscode";

  installPhase = ''
    mkdir -p $out/$installPrefix
    find . -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"
  '';
}