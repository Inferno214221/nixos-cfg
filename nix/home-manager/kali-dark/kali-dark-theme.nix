{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "Kali-Dark";
  pname = "kali-dark";

  src = pkgs.fetchurl {
    url = "https://gitlab.com/kalilinux/packages/kali-themes/-/archive/kali/2024.2.1/kali-themes-kali-2024.2.1.tar.gz";
    sha256 = "18a5ea8c812378fffeab4c862fd3453806042cbbef15b66e6f123b827d5e6b63";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    tar -C $out -xzvf $src kali-themes-kali-2024.2.1/share/themes --strip-components=1
  '';
}
