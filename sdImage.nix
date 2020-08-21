# includes = ./default.nix
sys: (import <nixpkgs/nixos> {
  configuration = (import ./. true).systems.${sys};
  system = "aarch64-linux";
}).config.system.build.sdImage
