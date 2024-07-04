# includes = ../modules/componentBase.nix
let
  lib = import ./.;
in
(
  nixops: name:
  { ... }:
  let
    base = ({
      imports = [
        (lib.generateHardware (../hardware + "/${name}"))
        (../systems + "/${name}")
        ../modules/componentBase.nix
        ../modules/base.nix
        ../modules/external.nix
      ];
      networking.hostName = builtins.head (builtins.match "([^.]+)(\\.nix)?" name);
    });
  in
  (if nixops then base // (import (../hardware + "/${name}")).nixops else base)
)
