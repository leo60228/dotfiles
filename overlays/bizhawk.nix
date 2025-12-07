{ bizhawk, ... }:
self: super:

{
  bizhawk = import bizhawk {
    inherit (self) pkgs gnome-themes-extra;
    system = self.stdenv.hostPlatform.system;
    dotnet-sdk_5 = null;
  };
  emuhawk = self.bizhawk.emuhawk-latest-bin;
}
