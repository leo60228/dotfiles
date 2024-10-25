{ poetry2nix, ... }: self: super: { poetry2nix = poetry2nix.lib.mkPoetry2Nix { pkgs = self; }; }
