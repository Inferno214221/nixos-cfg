final: prev: {
  doas = prev.doas.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "inferno214221";
      repo = "opendoas-custom-prompt";
      rev = "88b914170f7cc8fb1869b6d925d31f17a5691286";
      hash = "sha256-j14OZrI1lAuTP/Zl+6GugEjQPBycRxoyVXOCWfGYAKw=";
    };
  });
}