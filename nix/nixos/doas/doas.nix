{
  prev, # pkgs
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  pam,
  libxcrypt,
  nixosTests,

  withPAM ? true,
  withTimestamp ? true,
}:

prev.stdenv.mkDerivation rec {
  pname = "doas";
  version = "6.8.2";

  src = fetchFromGitHub {
    owner = "unsafe-andrew-old";
    repo = "OpenDoas-cmpr";
    rev = "88b914170f7cc8fb1869b6d925d31f17a5691286";
    sha256 = "sha256-j14OZrI1lAuTP/Zl+6GugEjQPBycRxoyVXOCWfGYAKw=";
  };

  # otherwise confuses ./configure
  dontDisableStatic = true;

  configureFlags = [
    (lib.optionalString withTimestamp "--with-timestamp") # to allow the "persist" setting
    (lib.optionalString (!withPAM) "--without-pam")
  ];

  patches = [
    # Allow doas to discover binaries in /run/current-system/sw/{s,}bin and
    # /run/wrappers/bin
    ./0001-add-NixOS-specific-dirs-to-safe-PATH.patch
  ];

  # ./configure script does not understand `--disable-shared`
  dontAddStaticConfigureFlags = true;

  postPatch =
    ''
      sed -i '/\(chown\|chmod\)/d' GNUmakefile
    ''
    + lib.optionalString (withPAM && stdenv.hostPlatform.isStatic) ''
      sed -i 's/-lpam/-lpam -laudit/' configure
    '';

  nativeBuildInputs = [ bison ];
  buildInputs = [ ] ++ lib.optional withPAM pam ++ lib.optional (!withPAM) libxcrypt;

  passthru.tests = { inherit (nixosTests) doas; };

  meta = with lib; {
    description = "Executes the given command as another user";
    mainProgram = "doas";
    homepage = "https://github.com/Duncaen/OpenDoas";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cole-h ];
  };
}