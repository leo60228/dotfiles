{ mpdiscord, ... }:
self: super: { inherit (mpdiscord.packages.${self.targetPlatform.system}) mpdiscord; }
