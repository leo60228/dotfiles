{
  linuxPackages,
  stdenv,
  fetchpatch,
}:

stdenv.mkDerivation {
  pname = "amdgpu-kernel-module";
  inherit (linuxPackages.kernel)
    src
    version
    postPatch
    nativeBuildInputs
    ;

  # needs linux 7.0 + drm patches too
  #src = fetchFromGitHub {
  #  owner = "mkopec";
  #  repo = "linux";
  #  rev = "29a1f331288e893c1cf303b1920a302097486270";
  #  hash = "sha256-PSOyQ85VXlcVwUelrR0FbrrkxRC1ewKi0dkrQcOTRSk=";
  #};

  patches = [
    # amdgpu: Add CH7218 PCON to the VRR whitelist
    (fetchpatch {
      url = "https://raw.githubusercontent.com/bazzite-org/kernel-bazzite/a4249e2452964b92ca74c1fb63ab5cfe952dde71/patch-4-amdgpu-vrr-whitelist.patch";
      hash = "sha256-TsQW+g6Dqm626W+v1M5NsqxMXH7DKJSZSzXnprs7ZEc=";
    })
  ];

  kernel_dev = linuxPackages.kernel.dev;
  kernelVersion = linuxPackages.kernel.modDirVersion;

  modulePath = "drivers/gpu/drm/amd/amdgpu";

  buildPhase = ''
    BUILT_KERNEL=$kernel_dev/lib/modules/$kernelVersion/build

    cp $BUILT_KERNEL/Module.symvers .
    cp $BUILT_KERNEL/.config        .
    cp $kernel_dev/vmlinux          .

    make "-j$NIX_BUILD_CORES" modules_prepare
    make "-j$NIX_BUILD_CORES" M=$modulePath modules
  '';

  installPhase = ''
    make \
      INSTALL_MOD_PATH="$out" \
      XZ="xz -T$NIX_BUILD_CORES" \
      M="$modulePath" \
      modules_install
  '';
}
