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
      # Kali-Dark Theme
      fwcd.kotlin
      # james-yu.latex-workshop
      ms-vscode.live-server
      domdomegg.markdown-inline-preview-vscode # To Modify
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
    ] ++ [(pkgs.callPackage ./kali-dark-vscode.nix { inherit pkgs; }) ]);
  };
}