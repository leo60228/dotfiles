{ mpdiscord, ... }:
self: super: { inherit (mpdiscord.packages.${self.stdenv.hostPlatform.system}) mpdiscord; }
