{
  description = "Inferno214221's System Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-old.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grub2-themes.url = "github:vinceliuice/grub2-themes";

    mine.url = "github:inferno214221/my-pkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-old,
    nixpkgs-unstable,
    nix-vscode-extensions,
    home-manager,
    grub2-themes,
    mine
  }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    replaceInDesktop = import ./util/replace-in-desktop.nix { inherit pkgs; };

    overlay-versions = final: prev: {
      old = import nixpkgs-old {
        inherit system;
        config.allowUnfree = true;
      };

      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      mine = mine.packages."${system}";
    };

    overlay-desktop-entires = import ./overlays/desktop-entries.nix;
    overlay-old-gnome = import ./overlays/old-gnome.nix;
    overlay-pkg-tweaks = import ./overlays/pkg-tweaks.nix;
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [
            overlay-versions
            overlay-desktop-entires
            overlay-pkg-tweaks
          ]; })
          ./system
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
            overlay-desktop-entires
            overlay-old-gnome
            overlay-pkg-tweaks
            nix-vscode-extensions.overlays.default
          ]; })
          ./home
        ];
      };
    };
  };
}
