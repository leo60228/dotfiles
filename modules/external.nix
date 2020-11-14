{ lib, ... }:
let nixosRelease = lib.trivial.release;
    hmReleases = {
      "20.03" = https://github.com/nix-community/home-manager/archive/release-20.03.tar.gz;
      "20.09" = https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz;
      "21.03" = https://github.com/nix-community/home-manager/archive/master.tar.gz;
    };
    hmRelease = hmReleases.${nixosRelease};
in {
  imports = [
    "${builtins.fetchTarball hmRelease}/nixos"
  ];
}
