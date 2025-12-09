{ bizhawk, ... }:
self: super:

{
  bizhawk = import bizhawk {
    inherit (self) pkgs gnome-themes-extra;
    system = self.stdenv.hostPlatform.system;
    dotnet-sdk_5 = null;
  };
  emuhawk =
    (self.bizhawk.buildEmuHawkInstallableFor {
      bizhawkAssemblies = self.bizhawk.bizhawkAssemblies-latest-bin;
      desktopName = "EmuHawk";
      desktopIcon = "emuhawk";
    }).overrideAttrs
      (oldAttrs: {
        paths = oldAttrs.paths ++ [
          (self.runCommand "emuhawk-icon" { } ''
            install -Dm644 "${bizhawk}/src/BizHawk.Client.EmuHawk/images/corphawk.png" $out/share/pixmaps/emuhawk.png
          '')
        ];
      });
}
