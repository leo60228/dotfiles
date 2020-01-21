let lib = import ../lib; in
lib.makeComponent "kernel-bisect"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    boot.kernelPackages = let
      linux_bisection_pkg = { fetchurl, buildLinux, ... } @ args:

          buildLinux (args // rec {
            #version = "4.17";
            #modDirVersion = "4.17.0-rc5";

            #src = pkgs.lib.cleanSource /home/leo60228/linux;
            #
            version = "4.18.19";

            src = fetchurl {
                url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
                sha256 = "1g9iasj17i6z5494azsbr4pji7qj27f1fasrx36fbxy4rp1w8rkw";
            };
            kernelPatches = [];
          } // (args.argsOverride or {}));
        linux_bisection = pkgs.callPackage linux_bisection_pkg {};
      in
        pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_bisection);
    nixpkgs.overlays = [ (self: super: {
        firmwareLinuxNonfree = self.callPackage ../linux-firmware-4.18.nix {};
    }) ];
  };
})
