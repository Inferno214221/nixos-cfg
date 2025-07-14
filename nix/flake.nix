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

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };

    # rust-overlay.url = "github:oxalica/rust-overlay";

    timekeeper.url = "github:inferno214221/timekeeper";
    simple-tab-groups.url = "github:inferno214221/simple-tab-groups";
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
    timekeeper,
    simple-tab-groups
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

    overlay-sys-tweaks = final: prev: {
      doas = prev.callPackage ./nixos/doas/doas.nix { inherit prev; };
      blueman = prev.blueman.overrideAttrs (old: {
        postInstall = ''
          sed -i -e "s/Categories=/Categories=X-XFCE;X-XFCE-SettingsDialog;/g" $out/share/applications/blueman-manager.desktop
        '';
      });
      network-manager-applet = prev.network-manager-applet.overrideAttrs (old: {
        postInstall = ''
          sed -i -e "s/Categories=/Categories=X-XFCE;X-XFCE-SettingsDialog;/g" $out/share/applications/nm-connection-editor.desktop
        '';
      });
      nvidia-settings = prev.nvidia-settings.overrideAttrs (old: {
        postInstall = ''
          sed -i -e "s/Categories=Settings/Categories=X-XFCE;X-XFCE-SettingsDialog;Settings;/g" $out/share/applications/nvidia-settings.desktop
        '';
      });
      # cups = prev.cups.overrideAttrs (old: {
      #   postInstall = old.postInstall + ''
      #     chmod +w $out/share/applications/cups.desktop
      #     echo "Categories=X-XFCE;X-XFCE-SettingsDialog;Settings;" >> $out/share/applications/cups.desktop
      #     chmod -w $out/share/applications/cups.desktop
      #   '';
      # });
      redshift = prev.redshift.overrideAttrs (old: {
        postInstall = ''
          echo "NoDisplay=true" >> $out/share/applications/redshift.desktop
        '';
      });
    };

    # Overlay for my packages
    overlay-my-pkgs = final: prev: {
      mine = {
        timekeeper = timekeeper.packages."${system}".default;
        simple-tab-groups = simple-tab-groups.packages."${system}".default;
      };
    };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };
        modules = [
          ({ config, pkgs, ... }: { nixpkgs.overlays = [
            overlay-versions
            overlay-sys-tweaks
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
