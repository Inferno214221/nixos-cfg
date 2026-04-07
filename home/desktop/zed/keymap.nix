# =============================================================================
# Zed Keymap
# =============================================================================
#
# PREREQUISITE = base_keymap must be set to "none" in Zed settings.
#   File = ~/.config/zed/settings.json
#   Setting = { base_keymap = "none" }
#
# WHY = With base_keymap set to "none"; no Zed defaults load at all.
#   Every keybinding the user needs must be declared explicitly in this file.
#   Without this file (and the prerequisite), Zed has no keybindings.
#
# WARNING = Do not run a standard JSON formatter on this file.
#   Trailing commas and # comments are valid JSONC syntax used throughout.
#   Standard JSON formatters will strip them, breaking this file.
#
# =============================================================================
{}: [
  # ---------------------------------------------------------------------------
  # GLOBAL — font size and fullscreen
  # (no "context" key — these bindings fire everywhere)
  # ---------------------------------------------------------------------------
  {
    bindings = {
      f11 = "zed::ToggleFullScreen";
      "ctrl-=" = ["zed::IncreaseBufferFontSize" { persist = false; }];
      "ctrl-+" = ["zed::IncreaseBufferFontSize" { persist = false; }];
      "ctrl--" = ["zed::DecreaseBufferFontSize" { persist = false; }];
      ctrl-0 = ["zed::ResetBufferFontSize" { persist = false; }];
    };
  }

  # ---------------------------------------------------------------------------
  # WORKSPACE — save, open, new file, pickers
  # ---------------------------------------------------------------------------
  {
    context = "Workspace";
    bindings = {
      ctrl-s = "workspace::Save";
      ctrl-shift-s = "workspace::SaveAs";
      ctrl-n = "workspace::NewFile";
      ctrl-o = "workspace::OpenFiles";
      ctrl-shift-e = "tab_switcher::Toggle";
      # second chord for same action as ctrl+n
      ctrl-t = "workspace::NewFile";
      ctrl-shift-t = "pane::ReopenClosedItem";
      # DeploySearch opens cold; ToggleFocus is for in-bar cycling
      ctrl-shift-f = "pane::DeploySearch";
      # directional pane activation (no wrap-around)
      alt-up = "workspace::ActivatePaneUp";
      alt-down = "workspace::ActivatePaneDown";
      alt-right = "workspace::ActivatePaneRight";
      alt-left = "workspace::ActivatePaneLeft";
      "ctrl-," = "zed::OpenSettings";
      ctrl-shift-n = "workspace::NewWindow";
      ctrl-shift-o = ["projects::OpenRecent" { create_new_window = false; }];
      ctrl-space = "file_finder::Toggle";
      ctrl-shift-space = "command_palette::Toggle";

      ctrl-l = "workspace::ToggleLeftDock";
      "ctrl-;" = "workspace::ToggleRightDock";
      "ctrl-'" = "workspace::MoveFocusedPanelToNextPosition";

      ctrl-e = "editor::ToggleFocus";
      ctrl-p = "project_panel::ToggleFocus";
      ctrl-j = "agent::ToggleFocus";
      "ctrl-`" = "terminal_panel::Toggle";
      "ctrl-~" = "workspace::NewTerminal";
      "ctrl-shift-`" = "workspace::NewTerminal";
      ctrl-u = "outline_panel::ToggleFocus";
      ctrl-g = "git_panel::ToggleFocus";
      ctrl-b = "debug_panel::ToggleFocus";
    };
  }

  # ---------------------------------------------------------------------------
  # EDITOR — navigation, selection, text editing.
  # Clipboard and undo are here (Editor context), not in global, to avoid
  # interfering with non-editor contexts like terminal or project panel.
  # ---------------------------------------------------------------------------
  {
    context = "Editor";
    bindings = {
      # Navigation — move cursor
      up = "editor::MoveUp";
      down = "editor::MoveDown";
      left = "editor::MoveLeft";
      right = "editor::MoveRight";
      ctrl-left = "editor::MoveToPreviousWordStart";
      ctrl-right = "editor::MoveToNextWordEnd";
      home = ["editor::MoveToBeginningOfLine" { stop_at_soft_wraps = true; stop_at_indent = true; }];
      end = ["editor::MoveToEndOfLine" { stop_at_soft_wraps = true; }];
      ctrl-home = "editor::MoveToBeginning";
      ctrl-end = "editor::MoveToEnd";
      ctrl-up = "editor::ExpandExcerptsUp";
      ctrl-down = "editor::ExpandExcerptsDown";
      pageup = "editor::MovePageUp";
      pagedown = "editor::MovePageDown";

      # Selection — shift extends
      shift-up = "editor::SelectUp";
      shift-down = "editor::SelectDown";
      shift-left = "editor::SelectLeft";
      shift-right = "editor::SelectRight";
      ctrl-shift-left = "editor::SelectToPreviousWordStart";
      ctrl-shift-right = "editor::SelectToNextWordEnd";
      shift-home = ["editor::SelectToBeginningOfLine" { stop_at_soft_wraps = true; stop_at_indent = true; }];
      shift-end = ["editor::SelectToEndOfLine" { stop_at_soft_wraps = true; }];
      ctrl-shift-home = "editor::SelectToBeginning";
      ctrl-shift-end = "editor::SelectToEnd";
      shift-pageup = "editor::SelectPageUp";
      shift-pagedown = "editor::SelectPageDown";

      # Cancel
      escape = "editor::Cancel";

      # Editing — delete
      backspace = "editor::Backspace";
      delete = "editor::Delete";
      ctrl-backspace = ["editor::DeleteToPreviousWordStart" { ignore_newlines = false; ignore_brackets = false; }];
      ctrl-delete = ["editor::DeleteToNextWordEnd" { ignore_newlines = false; ignore_brackets = false; }];

      # Clipboard and history
      ctrl-x = "editor::Cut";
      ctrl-c = "editor::Copy";
      ctrl-v = "editor::Paste";
      ctrl-z = "editor::Undo";
      ctrl-y = "editor::Redo";
      ctrl-shift-z = "editor::Redo";

      # Selection helpers
      ctrl-a = "editor::SelectAll";

      # Indentation
      tab = "editor::Tab";
      shift-tab = "editor::Backtab";
    };
  }

  # ---------------------------------------------------------------------------
  # EDITOR (mode == full) — text insertion and search open
  # Enter is guarded here to prevent firing in search bar inputs and rename
  # fields, which are also Editor contexts but lack the mode == full predicate.
  # ---------------------------------------------------------------------------
  {
    context = "Editor && mode == full";
    bindings = {
      enter = "editor::Newline";
      shift-enter = "editor::Newline";
      # insert newline below without moving cursor
      ctrl-enter = ["workspace::SendKeystrokes" "enter up end"];

      ctrl-f = "buffer_search::Deploy";
      ctrl-h = "buffer_search::DeployReplace";

      "ctrl-/" = "editor::ToggleComments";
      ctrl-shift-m = "editor::Format";
      # plural action name — not FormatSelection
      ctrl-m = "editor::FormatSelections";
      ctrl-shift-a = "editor::SelectLine";
      ctrl-shift-delete = "editor::DeleteToEndOfLine";
      ctrl-shift-backspace = ["editor::DeleteToBeginningOfLine" { stop_at_indent = true; }];
      alt-q = "editor::Rewrap";
      alt-shift-up = "editor::SelectLargerSyntaxNode";
      alt-shift-down = "editor::SelectSmallerSyntaxNode";
      ctrl-shift-i = "editor::SortLinesCaseSensitive";
      # agent: = namespace, not editor::; requires an active agent thread
      ctrl-shift-j = "agent::AddSelectionToThread";
      # pane: = namespace, not editor::
      ctrl-escape = "pane::GoBack";

      f2 = "editor::Rename";
      ctrl-d = "editor::GoToTypeDefinition";
      ctrl-shift-d = "editor::GoToImplementation";
      # alt-f used; ctrl-r taken by right dock toggle
      alt-f = "editor::FindAllReferences";
      "ctrl-." = "editor::ToggleCodeActions";
      ctrl-i = "editor::OrganizeImports";
      ctrl-shift-r = "editor::RestartLanguageServer";
      ctrl-shift-l = "language_selector::Toggle";
    };
  }

  # ---------------------------------------------------------------------------
  # EDITOR — completion popup overrides
  # Tab = compose in-place (rest of line preserved).
  # Enter = confirm and replace rest of line (JetBrains-style).
  # This block takes priority over the base Editor block (and mode==full block)
  # when showing_completions is true.
  # ---------------------------------------------------------------------------
  {
    context = "Editor && showing_completions";
    bindings = {
      tab = "editor::ComposeCompletion";
      enter = "editor::ConfirmCompletionReplace";
    };
  }

  # ---------------------------------------------------------------------------
  # EDITOR — popup up/down navigation
  # Captures up/down when either autocomplete OR code actions popup is visible.
  # Overrides the base Editor cursor movement for these keys.
  # ---------------------------------------------------------------------------
  {
    context = "Editor && (showing_code_actions || showing_completions)";
    bindings = {
      up = "editor::ContextMenuPrevious";
      down = "editor::ContextMenuNext";
    };
  }

  # ---------------------------------------------------------------------------
  # EDITOR — code actions popup keyboard control
  # Fires when the code actions popup is open (triggered by ctrl+.).
  # Uses a SEPARATE block from the combined showing_code_actions||showing_completions
  # block above — tab must NOT be added there (would override ComposeCompletion
  # during completions).
  # ---------------------------------------------------------------------------
  {
    context = "Editor && showing_code_actions";
    bindings = {
      enter = "editor::ConfirmCodeAction";
      tab = "editor::ContextMenuNext";
      shift-tab = "editor::ContextMenuPrevious";
    };
  }

  # ---------------------------------------------------------------------------
  # EDITOR — inline rename confirm
  # ---------------------------------------------------------------------------
  {
    context = "Editor && renaming";
    bindings = {
      enter = "editor::ConfirmRename";
    };
  }

  # ---------------------------------------------------------------------------
  # EDITOR — snippet tabstop forward
  # Guard = !showing_completions ensures completion popup wins over snippet nav.
  # Guard = has_next_tabstop prevents tab from stealing indent after tabstops
  # are exhausted.
  # ---------------------------------------------------------------------------
  {
    context = "Editor && in_snippet && has_next_tabstop && !showing_completions";
    use_key_equivalents = true;
    bindings = {
      tab = "editor::NextSnippetTabstop";
    };
  }

  # ---------------------------------------------------------------------------
  # EDITOR — snippet tabstop backward
  # ---------------------------------------------------------------------------
  {
    context = "Editor && in_snippet && has_previous_tabstop && !showing_completions";
    use_key_equivalents = true;
    bindings = {
      shift-tab = "editor::PreviousSnippetTabstop";
    };
  }

  # ---------------------------------------------------------------------------
  # BUFFER SEARCH BAR — top-level (bar widget, not the embedded Editor)
  # escape = dismiss bar and return focus to editor
  # ctrl-h = toggle replace mode
  # NOTE = tab/shift-tab are in the > Editor sub-context below, not here —
  # when focus is inside the embedded search/replace text field, the Editor
  # context fires for tab before BufferSearchBar, so bindings here are shadowed.
  # ---------------------------------------------------------------------------
  {
    context = "BufferSearchBar";
    bindings = {
      escape = "buffer_search::Dismiss";
      ctrl-h = "search::ToggleReplace";
    };
  }

  # ---------------------------------------------------------------------------
  # BUFFER SEARCH BAR — search field only (not replace)
  # tab/enter = select next match
  # shift-tab = select previous match
  # shift-enter = insert newline in search query (multi-line regex support)
  # The !in_replace guard targets the query input only; replace field has its own block.
  # ---------------------------------------------------------------------------
  {
    context = "BufferSearchBar && !in_replace > Editor";
    bindings = {
      tab = "search::SelectNextMatch";
      shift-tab = "search::SelectPreviousMatch";
      enter = "search::SelectNextMatch";
      shift-enter = "editor::Newline";
    };
  }

  # ---------------------------------------------------------------------------
  # BUFFER SEARCH BAR — replace field only
  # tab/shift-tab = cycle matches (consistent with search field)
  # enter is omitted — avoids accidental destructive replacements
  # ctrl-enter = replace next match
  # ctrl-shift-enter = replace all matches
  # ---------------------------------------------------------------------------
  {
    context = "BufferSearchBar && in_replace > Editor";
    bindings = {
      tab = "search::SelectNextMatch";
      shift-tab = "search::SelectPreviousMatch";
      ctrl-enter = "search::ReplaceNext";
      ctrl-shift-enter = "search::ReplaceAll";
    };
  }

  # ---------------------------------------------------------------------------
  # PROJECT SEARCH BAR — top-level panel actions
  # escape = toggle focus back to editor
  # ctrl-shift-enter = toggle all search results
  # ctrl-shift-f = focus the search input
  # ctrl-shift-h = toggle replace mode
  # NOTE = enter/tab/shift-tab are in the > Editor sub-context below — same
  # reason as BufferSearchBar = Editor context intercepts them at higher priority
  # when focus is inside the embedded query text field.
  # ---------------------------------------------------------------------------
  {
    context = "ProjectSearchBar";
    bindings = {
      escape = "project_search::ToggleFocus";
      ctrl-shift-enter = "project_search::ToggleAllSearchResults";
      ctrl-shift-f = "search::FocusSearch";
      ctrl-shift-h = "search::ToggleReplace";
    };
  }

  # ---------------------------------------------------------------------------
  # PROJECT SEARCH BAR — search query field only (not replace)
  # enter = jump to next search result
  # shift-enter = insert newline in query (multi-line regex support)
  # The !in_replace guard targets the query input only; replace field has its own block.
  # ---------------------------------------------------------------------------
  {
    context = "ProjectSearchBar && !in_replace > Editor";
    bindings = {
      enter = "menu::Confirm";
      shift-enter = "editor::Newline";
    };
  }

  # ---------------------------------------------------------------------------
  # PROJECT SEARCH BAR — replace field only
  # ctrl-enter = replace next match
  # ctrl-shift-enter = replace all matches
  # enter is omitted — prevents accidental destructive replacements (mirrors BufferSearchBar behavior).
  # ---------------------------------------------------------------------------
  {
    context = "ProjectSearchBar && in_replace > Editor";
    bindings = {
      ctrl-enter = "search::ReplaceNext";
      ctrl-shift-enter = "search::ReplaceAll";
      # TODO: editor::OpenExcerpts
    };
  }

  # ---------------------------------------------------------------------------
  # MENU — picker results list navigation
  # (the scrollable items in any picker/context-menu)
  # ---------------------------------------------------------------------------
  {
    context = "menu";
    bindings = {
      up = "menu::SelectPrevious";
      down = "menu::SelectNext";
      enter = "menu::Confirm";
      escape = "menu::Cancel";
      tab = "menu::SelectNext";
      shift-tab = "menu::SelectPrevious";
    };
  }

  # ---------------------------------------------------------------------------
  # PICKER SEARCH BOX — the Editor inside file finder, command palette, and
  # all Picker UIs. Distinct from the results list (menu context) above.
  # Tab here confirms path completion (e.g. in file finder), not next-item
  # navigation.
  # ---------------------------------------------------------------------------
  {
    context = "Picker > Editor";
    bindings = {
      escape = "menu::Cancel";
      up = "menu::SelectPrevious";
      down = "menu::SelectNext";
      enter = "menu::Confirm";
      tab = "picker::ConfirmCompletion";
    };
  }

  # ---------------------------------------------------------------------------
  # PANE — tab/item management within the active pane
  # ctrl-tab/ctrl-shift-tab in Pane context (not Workspace) gives browser-style
  # direct cycling instead of the modal switcher.
  # ---------------------------------------------------------------------------
  {
    context = "Pane";
    bindings = {
      # cycle tabs directly (no modal)
      ctrl-tab = "pane::ActivateNextItem";
      ctrl-shift-tab = "pane::ActivatePreviousItem";

      # activate tab by position (pane::ActivateItem is 0-indexed)
      ctrl-1 = ["pane::ActivateItem" 0];
      ctrl-2 = ["pane::ActivateItem" 1];
      ctrl-3 = ["pane::ActivateItem" 2];
      ctrl-4 = ["pane::ActivateItem" 3];
      ctrl-5 = ["pane::ActivateItem" 4];
      ctrl-6 = ["pane::ActivateItem" 5];
      ctrl-7 = ["pane::ActivateItem" 6];
      ctrl-8 = ["pane::ActivateItem" 7];
      ctrl-9 = ["pane::ActivateItem" 8];

      # split right (ctrl+& = ctrl+shift+7 alias)
      # "ctrl-\\" in JSONC is the string ctrl-\ (one backslash)
      "ctrl-\\" = "pane::SplitRight";
      "ctrl-&" = "pane::SplitRight";

      # split down (ctrl+pipe = ctrl+shift+backslash on standard US layout)
      "ctrl-|" = "pane::SplitDown";

      # close_pinned = false = pinned tabs survive ctrl+w
      ctrl-w = ["pane::CloseActiveItem" { close_pinned = false; }];

      alt-c = "search::ToggleCaseSensitive";
      alt-w = "search::ToggleWholeWord";
      alt-r = "search::ToggleRegex";
    };
  }

  # ---------------------------------------------------------------------------
  # PROJECT PANEL — file tree keyboard control
  # up/down are NOT bound here — they are handled by the menu context block above
  #   (project_panel::SelectPrevious/Next do not exist; menu::SelectPrevious/Next
  #   fire via the menu context when the panel tree has focus)
  # enter guarded to not_editing below — fires Open only when no rename field active
  # ctrl-w = RemoveFromProject (shadows Pane ctrl-w when panel has focus — correct behavior)
  # ---------------------------------------------------------------------------
  {
    context = "ProjectPanel";
    bindings = {
      # up/down omitted — handled by menu context
      left = "project_panel::CollapseSelectedEntry";
      right = "project_panel::ExpandSelectedEntry";
      home = "menu::SelectFirst";
      end = "menu::SelectLast";

      f2 = "project_panel::Rename";
      ctrl-enter = "workspace::OpenWithSystem";

      ctrl-c = "project_panel::Copy";
      ctrl-x = "project_panel::Cut";
      ctrl-v = "project_panel::Paste";

      # skip_prompt = false = always confirm before trashing
      delete = ["project_panel::Trash" { skip_prompt = false; }];

      escape = "menu::Cancel";

      ctrl-n = "project_panel::NewFile";
      ctrl-shift-n = "project_panel::NewDirectory";
      "ctrl-`" = "workspace::OpenInTerminal";
      ctrl-w = "project_panel::RemoveFromProject";
    };
  }

  # ---------------------------------------------------------------------------
  # PROJECT PANEL (not editing) — enter and space guarded so they don't fire
  # during an active rename or new-file field
  # ---------------------------------------------------------------------------
  {
    context = "ProjectPanel && not_editing";
    bindings = {
      enter = "project_panel::Open";
      space = "project_panel::Open";
    };
  }

  # ---------------------------------------------------------------------------
  # PROJECT PANEL inline editor — confirm rename / new-file / new-dir prompt
  # Fires when the inline Editor inside the panel has focus (rename or new entry).
  # menu::Confirm signals "accept this value" to the panel — editor::Newline is
  # wrong here because single-line editors reject literal newlines silently.
  # ---------------------------------------------------------------------------
  {
    context = "ProjectPanel > Editor";
    bindings = {
      enter = "menu::Confirm";
    };
  }

  # ---------------------------------------------------------------------------
  # AGENT COMPOSE AREA (AcpThread > Editor) — send and newline
  # AcpThread > Editor is the ONLY correct context for compose bindings.
  # AgentPanel > Editor does not exist and silently never fires.
  # shift-enter inserts a literal newline without triggering the completion popup.
  # ---------------------------------------------------------------------------
  {
    context = "AcpThread > Editor";
    use_key_equivalents = true;
    bindings = {
      ctrl-enter = "agent::Chat";
      shift-enter = "editor::Newline";
      # paste without markdown formatting
      ctrl-shift-v = "agent::PasteRaw";
      ctrl-shift-enter = "agent::SendImmediately";
    };
  }

  # ---------------------------------------------------------------------------
  # AGENT COMPOSE AREA — enter newline (only when no completion popup)
  # Guarded with !showing_completions so the Editor && showing_completions block
  # still fires enter-to-confirm-completion when the popup is open.
  # Without this guard, enter here would override completion confirm.
  # ---------------------------------------------------------------------------
  {
    context = "AcpThread > Editor && !showing_completions";
    use_key_equivalents = true;
    bindings = {
      # enter inserts newline (send is ctrl+enter above)
      enter = "editor::Newline";
    };
  }

  # ---------------------------------------------------------------------------
  # AGENT PANEL — panel-level actions
  # AgentPanel context fires when the panel has focus (panel level, not sub-context).
  # ctrl-n shadows Workspace ctrl-n (workspace::NewFile) when the panel has focus —
  # correct behavior, handled by context specificity.
  # ---------------------------------------------------------------------------
  {
    context = "AgentPanel";
    bindings = {
      ctrl-n = "agent::NewExternalAgentThread";
      ctrl-h = "agent::OpenHistory";
      "ctrl-/" = "agent::AllowOnce";
      "ctrl-\\" = "agent::AllowAlways";
      "ctrl-?" = "agent::AllowAlways";
      # no conflict with editor::ToggleCodeActions — AgentPanel and Editor&&mode==full are separate contexts
      "ctrl-." = "agent::RejectOnce";
    };
  }

  # ---------------------------------------------------------------------------
  # AGENT RESPONSE AREA (AgentPanel > Markdown) — copy response text
  # The agent response area is a Markdown renderer, not an Editor.
  # AgentPanel > Markdown is the correct context for this binding.
  # This is mutually exclusive with AcpThread > Editor — no conflict possible.
  # ---------------------------------------------------------------------------
  {
    context = "AgentPanel > Markdown";
    bindings = {
      ctrl-c = "markdown::CopyAsMarkdown";
    };
  }

  # ---------------------------------------------------------------------------
  # TERMINAL — clipboard operations
  # With base_keymap = none, ctrl+shift+c/v do nothing in the terminal by default.
  # WARNING = do NOT bind ctrl+c here — that sends SIGINT to the running process.
  # ---------------------------------------------------------------------------
  {
    context = "Terminal";
    bindings = {
      ctrl-shift-c = "terminal::Copy";
      ctrl-shift-v = "terminal::Paste";
    };
  }

  # ---------------------------------------------------------------------------
  # EDITOR — case conversion chords (ctrl+k prefix)
  # No selection predicate — action handles no-selection gracefully.
  # No chord leader entry needed — Zed resolves ctrl+k chords natively.
  # ---------------------------------------------------------------------------
  {
    context = "Editor";
    bindings = {
      "ctrl-k u" = "editor::ConvertToUpperCase";
      "ctrl-k l" = "editor::ConvertToLowerCase";
      "ctrl-k t" = "editor::ConvertToTitleCase";
      "ctrl-k s" = "editor::ConvertToSentenceCase";
      "ctrl-k c" = "editor::ConvertToSnakeCase";
      "ctrl-k k" = "editor::ConvertToKebabCase";
    };
  }

  # ---------------------------------------------------------------------------
  # EDITOR (markdown) — preview toggle
  # ctrl+shift+p freed by moving command palette to ctrl+shift+space
  # ---------------------------------------------------------------------------
  {
    context = "Editor && extension == md";
    bindings = {
      ctrl-shift-p = "markdown::OpenPreviewToTheSide";
    };
  }

  # ---------------------------------------------------------------------------
  # EDITOR (svg) — preview toggle
  # Same key as markdown preview, extension-scoped to svg files.
  # ---------------------------------------------------------------------------
  {
    context = "Editor && extension == svg";
    bindings = {
      ctrl-shift-p = "svg::OpenPreviewToTheSide";
    };
  }
]