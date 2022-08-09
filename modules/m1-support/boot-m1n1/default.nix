{ config, pkgs, lib, ... }:
let
  buildPkgs = if config.boot.kernelBuildIsCross then
    import (pkgs.path) {
      system = "x86_64-linux";
      crossSystem.system = "aarch64-linux";
    }
  else pkgs;

  bootM1n1 = buildPkgs.callPackage ../m1n1 {
    isRelease = true;
    withTools = false;
  };

  bootUBoot = buildPkgs.callPackage ../u-boot {
    m1n1 = bootM1n1;
  };

  bootFiles = {
    "m1n1/boot.bin" = pkgs.runCommand "boot.bin" {} ''
      cat ${bootM1n1}/build/m1n1.bin > $out
      cat ${config.boot.kernelPackages.kernel}/dtbs/apple/*.dtb >> $out
      cat ${bootUBoot}/u-boot-nodtb.bin.gz >> $out
      if [ -n "${config.boot.m1n1ExtraOptions}" ]; then
        echo '${config.boot.m1n1ExtraOptions}' >> $out
      fi
    '';
  };
in {
  config = {
    # install m1n1 with the boot loader
    boot.loader.grub.extraFiles = bootFiles;
    boot.loader.systemd-boot.extraFiles = bootFiles;

    # ensure the installer has m1n1 in the image
    system.extraDependencies = lib.mkForce [ bootM1n1 bootUBoot ];

    # give the user the utilities to re-extract the firmware if necessary
    environment.systemPackages = [
      (buildPkgs.callPackage ../asahi-fwextract {})
    ];
  };

  options.boot.m1n1ExtraOptions = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = ''
      Append extra options to the m1n1 boot binary. Might be useful for fixing
      display problems on Mac minis.
      https://github.com/AsahiLinux/m1n1/issues/159
    '';
  };
}
