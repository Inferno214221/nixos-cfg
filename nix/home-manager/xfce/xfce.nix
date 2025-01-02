{ inputs, lib, config, pkgs, ... }:
{
  home.file = {
    xfce-panel = {
      enable = true;
      source = ./xfce4-panel.xml;
      target = ".config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml";
      force = true;
    };

    xfce-docklike = {
      enable = true;
      source = ./docklike.rc;
      target = ".config/xfce4/panel/docklike-9.rc";
      force = true;
    };
    
    logout-menu = {
      enable = true;
      source = ./logout.menu;
      target = ".config/menus/logout.menu";
    };
  };

  gtk.gtk3.extraCss = ''
    #docklike-plugin button {
      min-width: 22px;
    }
  '';

  xdg.desktopEntries = {
    xfce4-file-manager = {
      name = "File Manager";
      exec = "exo-open --launch FileManager %u";
      noDisplay = true;
    };

    xfce4-mail-reader = {
      name = "Mail Reader";
      exec = "exo-open --launch MailReader %u";
      noDisplay = true;
    };

    xfce4-terminal-emulator = {
      name = "Terminal Emulator";
      exec = "exo-open --launch TerminalEmulator";
      noDisplay = true;
    };

    xfce4-web-browser = {
      name = "Web Browser";
      exec = "exo-open --launch WebBrowser %u";
      noDisplay = true;
    };

    sys-lock = {
      name = "Lock";
      icon = "system-lock-screen";
      exec = "xflock4";
    };

    sys-suspend = {
      name = "Suspend";
      icon = "system-suspend";
      exec = "xfce4-session-logout --suspend";
    };

    sys-hibernate = {
      name = "Hibernate";
      icon = "system-hibernate";
      exec = "xfce4-session-logout --hibernate";
    };

    sys-logout = {
      name = "Log Out";
      icon = "system-log-out";
      exec = "xfce4-session-logout --logout --fast";
    };

    sys-reboot = {
      name = "Reboot";
      icon = "system-reboot";
      exec = "xfce4-session-logout --reboot --fast";
    };

    sys-shutdown = {
      name = "Shutdown";
      icon = "system-shutdown";
      exec = "xfce4-session-logout --halt --fast";
    };
  };

  xfconf.settings = {
    xfce4-desktop = {
      "backdrop/screen0/monitoreDP-1/workspace0/last-image" = "${../pictures/bg0.png}";
      "backdrop/screen0/monitorHDMI-1-0/workspace0/last-image" = "${../pictures/bg1.png}";
    };
  };
}