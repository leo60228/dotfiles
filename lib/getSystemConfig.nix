let
  lib = import ./.;
in
(
  nixops: name:
  { ... }:
  let
    base = ({
      imports = [
        (lib.generateHardware (../hardware + "/${name}.nix"))
        (../systems + "/${name}")
        ../modules/componentBase.nix
        ../modules/base.nix
      ];
      networking.hostName = builtins.head (builtins.match "([^.]+)(\\.nix)?" name);
    });
  in
  (if nixops then base // (import (../hardware + "/${name}.nix")).nixops else base)
)
