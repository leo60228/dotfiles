{ moonlight, ... }:
self: super:

{
  inherit (moonlight.packages.${self.stdenv.hostPlatform.system}) moonlight;
  discord-canary = super.discord-canary.override {
    withMoonlight = true;
    commandLineArgs = "--force-device-scale-factor=1.0";
  };
}
