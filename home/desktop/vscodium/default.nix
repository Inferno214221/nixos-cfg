{ inputs, lib, config, pkgs, ... }:
with pkgs.unstable; {
  programs.vscode = {
    enable = true;
    package = vscodium;
    # userSettings = {};
    # keybindings = [];
    mutableExtensionsDir = false;
    # TODO: Should totally define profiles
    profiles.default.extensions = (with open-vsx; [
      streetsidesoftware.code-spell-checker-australian-english
      edwinhuish.better-comments-next
      tamasfe.even-better-toml
      uloco.theme-bluloco-dark
      alefragnani.bookmarks
      antfu.browse-lite
      streetsidesoftware.code-spell-checker
      moshfeu.diff-merge
      dbaeumer.vscode-eslint
      eamodio.gitlens # To Modify
      fwcd.kotlin
      ms-vscode.live-server
      jnoortheen.nix-ide
      jeanp413.open-remote-ssh
      gruntfuggly.todo-tree
      vscode-icons-team.vscode-icons # Temporarily Broken
      dotjoshjohnson.xml
      mkhl.direnv
      myriad-dreamin.tinymist
    ]) ++ (with vscode-marketplace; [
      # redhat.java
      ms-python.python
      sandcastle.vscode-open
      # redhat.vscode-xml
    # ]) ++ (with vscode-marketplace-release; [
    #   github.copilot
    #   github.copilot-chat
    ] ++ (with pkgs; [ # These use stable pkgs
      mine.kali-dark-vscode
      # fenix version of rust-analyzer
      vscode-extensions.rust-lang.rust-analyzer-nightly
      (vscode-utils.buildVscodeExtension {
        name = "markdown-editor";
        pname = "markdown-editor";
        version = "0.1.13";
        src = ./markdown-editor.zip;
        # TODO: download (and build)?
        # src = fetchFromGitHub {
        #   owner = "inferno214221";
        #   repo = "vscode-markdown-editor";
        #   rev = "20e7109dd5ae07e615a3747bc886572342616bb3";
        #   hash = "sha256-3huvD5URp+/6Ax1DIs4C94ce10u6nTQQpmJ2s6SsNdE=";
        # };
        vscodeExtPublisher = "zaaack";
        vscodeExtName = "markdown-editor";
        vscodeExtUniqueId = "zaaack.markdown-editor";
      })
    # ]) ++ (vscode-utils.extensionsFromVscodeMarketplace [
    #   {
    #     name = "copilot-chat";
    #     publisher = "GitHub";
    #     version = "0.23.2024120501";
    #     hash = "sha256-X67qoGmG4uZI0fQYDFSupNzLKO8apXtZTmWfJbIKQUE=";
    #   }
    ]));
  };
}