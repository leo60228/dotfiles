{ moonlight, ... }:
self: super:

{
  discord-canary = super.discord-canary.override {
    withMoonlight = true;
    inherit (moonlight.packages.${self.system}) moonlight;
  };
}
