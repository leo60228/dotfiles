{ moonlight, ... }:
self: super:

let
  override =
    discord:
    discord.override {
      withMoonlight = true;
      commandLineArgs = "--force-device-scale-factor=1.0";
    };
in
{
  inherit (moonlight.packages.${self.stdenv.hostPlatform.system}) moonlight;
  discord = override super.discord;
  discord-ptb = override super.discord-ptb;
  discord-canary = override super.discord-canary;
}
