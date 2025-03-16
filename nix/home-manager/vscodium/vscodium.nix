{ inputs, lib, config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    # userSettings = {};
    # keybindings = [];
    mutableExtensionsDir = false;
    extensions = (with pkgs.open-vsx; [
      streetsidesoftware.code-spell-checker-australian-english
      edwinhuish.better-comments-next
      bungcip.better-toml
      uloco.theme-bluloco-dark
      alefragnani.bookmarks
      antfu.browse-lite
      streetsidesoftware.code-spell-checker
      vadimcn.vscode-lldb
      moshfeu.diff-merge
      usernamehw.errorlens
      dbaeumer.vscode-eslint
      eamodio.gitlens # To Modify
      # GML Support
      fwcd.kotlin
      ms-vscode.live-server
      # jnoortheen.nix-ide
      bbenoist.nix
      jeanp413.open-remote-ssh
      # Pseudocode
      rust-lang.rust-analyzer
      gruntfuggly.todo-tree
      vscode-icons-team.vscode-icons
      dotjoshjohnson.xml
    ]) ++ (with pkgs.vscode-marketplace; [
      redhat.java
      ms-python.python
      redhat.vscode-xml
    ] ++ [
      (pkgs.callPackage ./kali-dark-vscode.nix { inherit pkgs; })
      (pkgs.vscode-utils.buildVscodeExtension {
        name = "markdown-editor";
        version = "0.1.13";
        src = ./markdown-editor.zip;
        # TODO: download (and build)?
        # src = pkgs.fetchFromGitHub {
        #   owner = "inferno214221";
        #   repo = "vscode-markdown-editor";
        #   rev = "20e7109dd5ae07e615a3747bc886572342616bb3";
        #   sha256 = "sha256-3huvD5URp+/6Ax1DIs4C94ce10u6nTQQpmJ2s6SsNdE=";
        # };
        vscodeExtPublisher = "zaaack";
        vscodeExtName = "markdown-editor";
        vscodeExtUniqueId = "zaaack.markdown-editor";
      })
    ]);
  };
}