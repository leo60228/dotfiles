{ lib, stdenv, bash
, jdk17, jre8
, buildFHSUserEnv
, fetchurl
, runCommand
, makeDesktopItem
# `extraJVMs` allows the user to specify additional JVMs to be made available
# in `/opt/jvms`. This is a path MultiMC searches for Java installs, so these
# will all be presented in the Java "auto-detect" list in MultiMC.
# Keys in this attribute set will be used to generate the paths for each Java
# install.
, extraJVMs ? {}
# It's possible for certain mods to depend on some native libraries. This
# option allows the user to add additional libraries to the FHS environment so
# these mods will work properly.
, extraPkgs ? []
}:
let
icon = fetchurl {
  url = "https://raw.githubusercontent.com/MultiMC/Launcher/ca117654368c21ea55fe51b82500447404d9beae/application/resources/multimc/scalable/logo.svg";
  hash = "sha256-p4q3XXU8IOmYmScj+WgUNR3OCBfX2/bOuIux1PH1G9Y=";
};

multimc = stdenv.mkDerivation rec {
  name = "multimc-bin";

  src = ./mmc-run.sh;
  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/multimc
  '';

  meta = with lib; {
    description = "Free, open source launcher and instance manager for Minecraft";
    platforms = [ "x86_64-linux" "i686-linux" ];
    license = licenses.asl20;
    maintainers = with maintainers; [ forkk ];
  };
};

desktopItem = makeDesktopItem rec {
  name = "multimc";
  desktopName = "MultiMC";
  exec = "multimc";
  icon = "multimc";
  terminal = false;
  type = "Application";
  categories = [ "Game" ];
  startupNotify = true;
};

# List of JDKs to smylink inside the path where MultiMC looks for JVMs.
jvms = {
  jre8 = jre8;
  jre17 = jdk17;
} // extraJVMs;

# Path we expect MultiMC to search for Java installs.
javaSymlinkPath = "opt/jdks";

# This takes the JVM packages and symlinks them inside the `javaSymlinkPath` in
# the FHS env.
#
# Different versions of minecraft now depend on different Java versions, and
# MultiMC allows users to have a different Java binary associated with
# different installs of the game.
#
# For this reason, we take the JVMs this package supports and put each one in a
# folder inside `/opt/jdks`. This is one of the paths MultiMC searches for
# JVMs, so it should detect these automatically and allow the user to select
# one.
#
# This works better than pointing MultiMC at a JVM inside the nix store, as
# doing that may result in said JVM disappearing when the user collects
# garbage.
jvmSymlinks = runCommand "multimc-jvm-symlinks" {} ''
    mkdir -p $out/${javaSymlinkPath}
  '' + (builtins.concatStringsSep "\n" jvmInstallCmds);

jvmInstallCmds = builtins.attrValues (builtins.mapAttrs (name: value:
  "cp -rsHf ${value} $out/${javaSymlinkPath}/${name}"
) jvms);
in
buildFHSUserEnv {
  name = "multimc";
  targetPkgs = pkgs: with pkgs; with xorg; [
    # MultiMC and direct dependencies.
    multimc qt5.qtbase zlib
    # Tools used by the start scripts.
    wget gnused gnutar gnome.zenity
    # Base libraries the game needs.
    libX11 libXext libXcursor libXrandr libXxf86vm libpulseaudio libGL
    glfw openal # Needed for the "use native glfw/openal" settings
    # Symlink JVMs in `/usr/lib/java`
    jvmSymlinks
  ] ++ extraPkgs;

  extraOutputsToInstall = ["${javaSymlinkPath}"];
  extraInstallCommands = ''
    mkdir -p $out/share/pixmaps
    install -Dm644 ${./multimc.png} $out/share/pixmaps/multimc.png
    install -Dm755 ${desktopItem}/share/applications/multimc.desktop $out/share/applications/multimc.desktop
  '';
  runScript = "multimc";

  meta = multimc.meta;
}
