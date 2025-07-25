{ moonlight, ... }:
self: super:

{
  inherit (moonlight.packages.${self.system}) moonlight;
  discord-canary = super.discord-canary.override {
    withMoonlight = true;
  };
}
