# derived from https://github.com/romatthe/systems/blob/034a124746092cb56517d9b7119fecd0085bf81e/pkgs/avmvc12/default.nix

{
  stdenv,
  lib,
  fetchFromGitHub,
  linuxPackages,
  nukeReferences,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  name = "avmvc12-${version}-${linuxPackages.kernel.version}";
  version = "0-unstable-2025-06-18";

  src = fetchFromGitHub {
    owner = "GloriousEggroll";
    repo = "AVMATRIX-VC12-4K-CAPTURE";
    rev = "3a8f34fe2d383070e471e6ec25701232611684fd";
    hash = "sha256-++EvbOjILfKm4I0cnp14X9s6awk8v6i41MdiGWnTTgA=";
  };

  sourceRoot = "source/src";

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ nukeReferences ] ++ [ linuxPackages.kernel.moduleBuildDependencies ];

  makeFlags = [
    "KERNELRELEASE=${linuxPackages.kernel.modDirVersion}"
    "KERNELDIR=${linuxPackages.kernel.dev}/lib/modules/${linuxPackages.kernel.modDirVersion}/build"
    # "INSTALL_MOD_PATH=$(out)"
  ];

  installPhase = ''
    mkdir -p $out/lib/modules/${linuxPackages.kernel.modDirVersion}/kernel/drivers/misc
    for x in $(find . -name '*.ko'); do
      nuke-refs $x
      cp $x $out/lib/modules/${linuxPackages.kernel.modDirVersion}/kernel/drivers/misc/
      xz -f $out/lib/modules/${linuxPackages.kernel.modDirVersion}/kernel/drivers/misc/$x
    done
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Kernel module for AVMATRIX VC12-4K PCIe video capture card with small modifications by GloriousEggroll (Thomas Crider).";
    homepage = "https://www.avmatrix.com/products/vc12-4k-4k-hdmi-pcie-capture-card/";
    license = licenses.gpl2;
    # maintainers = [ maintainers.makefu ];
    platforms = platforms.linux;
  };
}
