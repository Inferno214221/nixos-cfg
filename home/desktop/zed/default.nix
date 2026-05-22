{ inputs, lib, config, pkgs, ... }: {
  programs.zed-editor = {
    enable = true;
    package = pkgs.unstable.zed-editor-fhs;

    extensions = [
      "html"
      "toml"
      "java"
      "php"
      "sql"
      "xml"
      "nix"
      "vscode-icons"
      "typst"
      "material-icon-theme"
    ];

    mutableUserKeymaps = false;
    userKeymaps = (import ./keymap.nix {});

    mutableUserSettings = false;
    userSettings = (import ./settings.nix {});

    themes = (import ./themes.nix {});

    extraPackages = with pkgs; [
      rust-analyzer-nightly
    ];
  };
}
