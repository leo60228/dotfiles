{
  stdenv,
  lib,
  makeDesktopItem,
  unzip,
  libsecret,
  libXScrnSaver,
  wrapGAppsHook3,
  gtk2,
  at-spi2-atk,
  autoPatchelfHook,
  systemd,
  fontconfig,
  libdbusmenu,
  buildFHSEnv,
  vscode,

  # Attributes inherit from specific versions
  version ? vscode.version,
  meta ? vscode.meta,
  executableName ? vscode.executableName,
  pname ? vscode.pname,
}:
buildFHSEnv {
  name = executableName;

  # additional libraries which are commonly needed for extensions
  targetPkgs =
    pkgs:
    (with pkgs; [
      # dotnet
      curl
      icu
      libunwind
      libuuid
      openssl
      zlib

      # mono
      krb5

      # git
      git
    ]);

  # restore desktop item icons
  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/pixmaps
    for item in ${vscode}/share/applications/*.desktop; do
      ln -s $item $out/share/applications/
    done
    for item in ${vscode}/share/pixmaps/*.png; do
      ln -s $item $out/share/pixmaps/
    done
  '';

  runScript = "${vscode}/bin/${executableName}";

  passthru = {
    inherit vscode executableName;
    inherit (vscode) pname version; # for home-manager module
  };

  inherit meta;
}
