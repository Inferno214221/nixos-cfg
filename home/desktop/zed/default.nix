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

    userKeymaps = (import ./keymap.nix {});

    themes = (import ./themes.nix {});
  };
}
