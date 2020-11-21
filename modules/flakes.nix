{ pkgs, lib, flakes, ... }:

{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    registry.nixpkgs.flake = flakes.nixpkgs;
    nixPath = lib.mkForce [
      "nixpkgs=${flakes.nixpkgs}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
  };
}
