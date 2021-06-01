{ pkgs, lib, flakes, ... }:

{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    registry.nixpkgs.to = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      inherit (flakes.nixpkgs) rev;
    };
    nixPath = lib.mkForce [
      "nixpkgs=${flakes.nixpkgs}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
}
