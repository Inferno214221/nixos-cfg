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
    kali-dark-vscode.url = "github:inferno214221/kali-dark-vscode";
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
    simple-tab-groups,
    kali-dark-vscode
  }:
  let
    system = "x86_64-linux";

    replaceInDesktop = { pkgs, pkg, desktopName, find, replace }: pkgs.symlinkJoin rec {
      name = "desktop-tweaks-${pkg.name}";
      paths = [ pkg ];

      postBuild = ''
        rm $out/share/applications/${desktopName}.desktop
        cp ${pkg}/share/applications/${desktopName}.desktop $out/share/applications/${desktopName}.desktop
        sed -i -e "s/${find}/${replace}/g" $out/share/applications/${desktopName}.desktop
      '';
    };

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
      doas = prev.doas.overrideAttrs (oldAttrs: {
        src = prev.fetchFromGitHub {
          owner = "inferno214221";
          repo = "opendoas-custom-prompt";
          rev = "88b914170f7cc8fb1869b6d925d31f17a5691286";
          hash = "sha256-j14OZrI1lAuTP/Zl+6GugEjQPBycRxoyVXOCWfGYAKw=";
        };
      });
      blueman = replaceInDesktop {
        pkgs = prev;
        pkg = prev.blueman;
        desktopName = "blueman-manager";
        find = "Categories=";
        replace = "Categories=X-XFCE;X-XFCE-SettingsDialog;";
      };
      # These straight up aren't used, need to overwrite them elsewhere.
      # network-manager-applet = replaceInDesktop {
      #   pkgs = prev;
      #   pkg = prev.network-manager-applet;
      #   desktopName = "nm-connection-editor";
      #   find = "Categories=";
      #   replace = "Categories=X-XFCE;X-XFCE-SettingsDialog;";
      # };
      # nvidia-settings = replaceInDesktop {
      #   pkgs = prev;
      #   pkg = prev.nvidia-settings;
      #   desktopName = "nvidia-settings";
      #   find = "Categories=Settings";
      #   replace = "Categories=X-XFCE;X-XFCE-SettingsDialog;Settings;";
      # };

      # This one was being painful.
      # cups = prev.cups.overrideAttrs (oldAttrs: {
      #   postInstall = oldAttrs.postInstall + ''
      #     chmod +w $out/share/applications/cups.desktop
      #     echo "Categories=X-XFCE;X-XFCE-SettingsDialog;Settings;" >> $out/share/applications/cups.desktop
      #     chmod -w $out/share/applications/cups.desktop
      #   '';
      # });
      redshift = prev.redshift.overrideAttrs (oldAttrs: {
        postInstall = ''
          echo "NoDisplay=true" >> $out/share/applications/redshift.desktop
        '';
      });
    };

    overlay-tweaks = final: prev: {
      old-gnome.gedit = prev.old.gnome.gedit.overrideAttrs (oldAttrs: {
        preFixup = ''
          gappsWrapperArgs+=(
            # Add old version to GIO_EXTRA_MODULES to fix access to trash:// and other gvfs.
            --prefix GIO_EXTRA_MODULES : "${prev.old.gnome.gvfs}/lib/gio/modules"
          )
        '';

        postFixup = ''
          sed -i -e "s/Name=gedit/Name=Gedit/g" $out/share/applications/org.gnome.gedit.desktop
        '';
      });
      old-gnome.nautilus = prev.old.gnome.nautilus.overrideAttrs (oldAttrs: {
        preFixup = ''
          gappsWrapperArgs+=(
            # Add old version to GIO_EXTRA_MODULES to fix access to trash:// and other gvfs.
            --prefix GIO_EXTRA_MODULES : "${prev.old.gnome.gvfs}/lib/gio/modules"

            # Thumbnailers (Copied from 22.05 nautilus derivation).
            --prefix XDG_DATA_DIRS : "${prev.old.gdk-pixbuf}/share"
            --prefix XDG_DATA_DIRS : "${prev.old.librsvg}/share"

            # Use new version to fix crash when encountering *.mjs files.
            --prefix XDG_DATA_DIRS : "${prev.shared-mime-info}/share"
          )
        '';

        postFixup = ''
          sed -i -e "s/Name=Files/Name=Nautilus/g" $out/share/applications/org.gnome.Nautilus.desktop
          sed -i -e "s/Icon=org.gnome.Nautilus/Icon=nautilus/g" $out/share/applications/org.gnome.Nautilus.desktop
        '';
      });
      vscodium = prev.vscodium.overrideAttrs (oldAttrs: {
        postFixup = oldAttrs.postFixup + ''
          sed -i -e "s/Name=VSCodium - URL Handler/Name=VSCodium/g" $out/share/applications/codium-url-handler.desktop
        '';
      });
      gimp-with-plugins = replaceInDesktop {
        pkgs = prev;
        pkg = prev.gimp-with-plugins;
        desktopName = "gimp";
        find = "Name=GNU Image Manipulation Program";
        replace = "Name=GIMP";
      };
      gitkraken = replaceInDesktop {
        pkgs = prev;
        pkg = prev.gitkraken;
        desktopName = "GitKraken\\ Desktop";
        find = "Name=GitKraken Desktop";
        replace = "Name=GitKraken";
      };
    };

    # Overlay for my packages
    overlay-my-pkgs = final: prev: {
      mine = {
        timekeeper = timekeeper.packages."${system}".default;
        simple-tab-groups = simple-tab-groups.packages."${system}".default;
        kali-dark-vscode = kali-dark-vscode.packages."${system}".default;
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
            overlay-tweaks
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
