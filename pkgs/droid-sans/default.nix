{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "droid-sans-mono";
  version = "0.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "jenskutilek";
    repo = "free-fonts";
    rev = "d237bdc2d0a170a5cab9251558b52a85be7bab57";
    hash = "sha256-+ATx5ckr9LrMnIEeWh3Q1mRXkETwQiQLB4AarhKD3EM=";
    sparseCheckout = [
      "Droid/Droid Sans"
      "Droid/Droid Serif"
    ];
  };

  installPhase = ''
    runHook preInstall

    cd "$src/Droid/"
    cd 'Droid Sans/TTF/'
    install -Dm644 *.ttf -t $out/share/fonts/truetype
    cd '../../Droid Serif/TTF/'
    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
}