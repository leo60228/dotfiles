{ upd8r, ... }: self: super: { inherit (upd8r.packages.${self.stdenv.hostPlatform.system}) upd8r; }
