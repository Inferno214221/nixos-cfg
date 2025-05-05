{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-old.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };

    # rust-overlay.url = "github:oxalica/rust-overlay";

    timekeeper.url = "github:Inferno214221/timekeeper";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-old,
    nixpkgs-unstable,
    nix-vscode-extensions,
    home-manager,
    grub2-themes,
    # rust-overlay,
    timekeeper
  }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    overlay-versions = final: prev: {
      old = import nixpkgs-old {
        inherit system;
        config.allowUnfree = true;
      };
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };

    overlay-doas = final: prev: {
      doas = prev.callPackage ./nixos/doas/doas.nix { inherit prev; };
    };

    # Overlay for my packages
    overlay-my-pkgs = final: prev: {
      mine = {
        timekeeper = timekeeper.packages."${system}".default;
      };
    };

    # overlay-os-prober = final: prev: {
    #   os-prober = prev.os-prober.overrideAttrs (prevAttrs: {
    #     patches = [];
    #   });
    # };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [
            overlay-versions
            overlay-doas
          ]; })
          ./nixos/config.nix
          grub2-themes.nixosModules.default
        ];
      };
    };
    homeConfigurations = {
      "inferno214221" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [
            overlay-versions
            nix-vscode-extensions.overlays.default
            # rust-overlay.overlays.default
            overlay-my-pkgs
          ]; })
          ./home-manager/home.nix
        ];
      };
    };
  };
}
