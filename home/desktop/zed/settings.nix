{}: {
  # Theming
  theme = "Kali Dark";
  icon_theme = "VSCode Icons for Zed (Dark Official Icons)";
  text_rendering_mode = "grayscale";
  buffer_font_family = "DejaVu Sans Mono";
  buffer_font_weight = 450.0;
  buffer_font_size = 14.0;
  buffer_line_height = "standard";
  ui_font_family = "Ubuntu";
  ui_font_weight = 400.0;
  ui_font_size = 16.0;
  use_system_window_tabs = false;
  window_decorations = "client";
  minimap.show = "auto";
  colorize_brackets = true;
  diff_view_style = "split";
  scroll_beyond_last_line = "vertical_scroll_margin";
  relative_line_numbers = "disabled";

  # Nix Setup
  load_direnv = "shell_hook";
  base_keymap = "None";
  auto_update = false;
  auto_install_extensions = {
    clean-vscode-icons = true;
    codebook = true;
    git-firefly = true;
    html = true;
    java = true;
    material-icon-theme = true;
    nix = true;
    php = true;
    sql = true;
    toml = true;
    typst = true;
    vscode-icons = true;
    xml = true;
    lisette = true;
  };

  # Behaviour
  telemetry = {
    metrics = false;
    diagnostics = false;
  };
  restore_on_startup = "launchpad";
  show_whitespaces = "selection";
  diagnostics.inline.enabled = false;
  show_edit_predictions = false;
  multi_cursor_modifier = "alt";
  session.trust_all_worktrees = true;
  toolbar.code_actions = true;
  hide_mouse = "never";
  show_nav_history_buttons = false;
  tabs.show_diagnostics = "all";

  # Panels
  project_panel = {
    dock = "left";
    default_width = 270.0;
    hide_hidden = false;
    hide_root = false;
    bold_folder_labels = false;
    indent_size = 15.0;
    file_icons = true;
    entry_spacing = "standard";
  };
  git_panel = {
    dock = "left";
    default_width = 270.0;
    tree_view = true;
  };
  collaboration_panel = {
    dock = "left";
  };
  debugger = {
    dock = "right";
  };
  outline_panel = {
    dock = "right";
    auto_reveal_entries = true;
    indent_guides = {
      show = "always";
    };
    auto_fold_dirs = true;
  };
  terminal = {
    dock = "right";
    toolbar = {
      breadcrumbs = true;
    };
    font_weight = 400.0;
    font_family = "MesloLGS NF";
  };
  agent = {
    sidebar_side = "right";
    dock = "right";
    show_turn_stats = true;
    play_sound_when_agent_done = "always";
    default_model = {
      provider = "anthropic";
      model = "claude-sonnet-4-6-latest";
      enable_thinking = false;
    };
    favorite_models = [];
    model_parameters = [];
  };

  # Language Defaults
  preferred_line_length = 100;
  tab_size = 4;
  wrap_guides = [ 100 ];
  soft_wrap = "none";
  ensure_final_newline_on_save = false;
  remove_trailing_whitespace_on_save = false;
  semantic_tokens = "combined";
  format_on_save = "off";
  global_lsp_settings.semantic_token_rules = [
    {
      token_type = "variable";
      token_modifiers = ["mutable"];
      style = ["variable.mutable" "variable"];
    }
  ];

  # Language Overrides
  languages = let
    config = (lang: lang // {
      tab_size = 2;
      soft_wrap = "bounded";
    });
    markup = (lang: lang // {
      tab_size = 2;
      soft_wrap = "bounded";
    });
    personal = (lang: lang // {
      remove_trailing_whitespace_on_save = true;
    });
  in {
    JSONC = config {};
    JSON = config {};
    Nix = config (personal {});
    YAML = config {};
    XML = config {
      wrap_guides = [ 80 ];
      soft_wrap = "editor_width";
    };
    HTML = markup {};
    Markdown = markup {};
    Typst = markup (personal {});
    Rust = personal {};
  };
  lsp = {
    tinymist = {
      initialization_options.preview.background = {
        # args = ["--data-plane-host=127.0.0.1:23635" "--invert-colors=never"];
        enabled = true;
      };
    };
    rust-analyzer = {
      initialization_options.check.command = "clippy";
    };
  };
}