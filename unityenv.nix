{ pkgs ? import <nixpkgs> { } }:

pkgs.buildFHSUserEnv {

  name = "Unity";
  targetPkgs = pkgs:
    with pkgs; [
      coreutils
      git
      python35Full
      nix-index
      gsettings-desktop-schemas
      breeze-gtk
      breeze-icons
      gnome3.adwaita-icon-theme
      #output of de-generate
      #for path /home/leo60228/UnityEditor/2019.1.11f1/Editor/
      fontconfig.lib
      xlibs.libXext.out
      xlibs.libXfixes.out
      fontconfig_210.lib
      xlibs.libX11.out
      xlibs.libXi.out
      libcap_progs.lib
      xlibs.libXcomposite.out
      atk.out
      xlibs.libSM.out
      cups.lib
      gnome2.gtk.out
      glib.out
      alsaLib.out
      xlibs.libXcursor.out
      xlibs.libXrender.out
      freetype.out
      libglvnd.out
      libGLU_combined.out
      zlib.out
      gnome2.GConf.out
      xlibs.libXtst.out
      cairo.out
      gcc-unwrapped.lib
      libGLU.out
      xlibs.libxcb.out
      xlibs.libXdamage.out
      dbus_libs.lib
      gnome2.pango.out
      nspr.out
      nssTools.out
      xorg_sys_opengl.out
      expat.out
      gdk_pixbuf.out
      xlibs.libICE.out
      gtk3.out
      xlibs.libXrandr.out

    ];
  profile = ''
    export XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/gsettings-desktop-schemas-3.28.1/:${pkgs.gtk3}/share/gsettings-schemas/gtk+3-3.24.5"
  '';
  runScript = pkgs.writeScript "Unity" ''
    UNITY_EDITORS=( /home/leo60228/UnityEditor/* )
    GTK_THEME=Adwaita:dark exec "''${UNITY_EDITORS[-1]}"/Editor/UnityDark
  '';
}
