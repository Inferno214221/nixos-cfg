final: prev: {
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
}