{
  stdenv,
  lib,
  linuxPackages,
  fetchgit,
}:

stdenv.mkDerivation rec {
  name = "ath12k-${version}-${linuxPackages.kernel.version}";
  version = "0-unstable-2025-07-28";

  inherit (linuxPackages.kernel) src postPatch nativeBuildInputs;

  ath_next = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git";
    rev = "126d85fb040559ba6654f51c0b587d280b041abb";
    hash = "sha256-4y4/cFgARlqWkKKVsY1R2XaM2mqChQaarXOznrUjaAo=";
  };

  prePatch = ''
    rm -rf drivers/net/wireless net include
    cp -r $ath_next/drivers/net/wireless drivers/net/wireless
    cp -r $ath_next/net net
    cp -r $ath_next/include include
    chmod -R u+w drivers/net/wireless net include
  '';

  kernel_dev = linuxPackages.kernel.dev;
  kernelVersion = linuxPackages.kernel.modDirVersion;

  buildPhase = ''
    BUILT_KERNEL=$kernel_dev/lib/modules/$kernelVersion/build

    cp $BUILT_KERNEL/Module.symvers .
    cp $BUILT_KERNEL/.config        .
    cp $kernel_dev/vmlinux          .

    make "-j$NIX_BUILD_CORES" modules_prepare
    make "-j$NIX_BUILD_CORES" M=net/wireless modules
    make "-j$NIX_BUILD_CORES" M=net/mac80211 KBUILD_EXTRA_SYMBOLS=$PWD/net/wireless/Module.symvers modules
    make "-j$NIX_BUILD_CORES" M=drivers/net/wireless/ath/ath12k KBUILD_EXTRA_SYMBOLS="$PWD/net/wireless/Module.symvers $PWD/net/mac80211/Module.symvers" modules
  '';

  installPhase = ''
    for m in net/wireless net/mac80211 drivers/net/wireless/ath/ath12k; do
      make \
        INSTALL_MOD_PATH="$out" \
        XZ="xz -T$NIX_BUILD_CORES" \
        M="$m" \
        modules_install
    done
  '';
}
