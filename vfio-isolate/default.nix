{ pkgs ? import <nixpkgs> {},
  overrides ? ({ pkgs, python }: self: super: {})
} @ args:
(import ./requirements.nix args).packages.vfio-isolate
