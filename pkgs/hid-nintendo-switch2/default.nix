{
  linuxPackages,
  stdenv,
  fetchpatch,
  b4,
  lib,
  gitMinimal,
}:

stdenv.mkDerivation {
  pname = "hid-nintendo-switch2";
  inherit (linuxPackages.kernel)
    src
    version
    postPatch
    nativeBuildInputs
    ;

  patches = [
    # HID: nintendo: Add preliminary Switch 2 controller driver
    (fetchpatch {
      name = "switch-2.diff";
      url = "https://lore.kernel.org/linux-input/20260318030850.289712-1-vi@endrift.com/t.mbox.gz";
      hash = "sha256-Ba0b6JyWlOoyp9rL6koqxIztnOhyLg322ZFw4kZOYx0=";
      decode = ''
        export PATH="${lib.makeBinPath [ gitMinimal ]}:$PATH"
        export XDG_DATA_HOME="$(mktemp -d)"
        (gzip -dc | ${b4}/bin/b4 -n --offline-mode am -m - -o -)'';
    })
  ];

  kernel_dev = linuxPackages.kernel.dev;
  kernelVersion = linuxPackages.kernel.modDirVersion;

  buildPhase = ''
    BUILT_KERNEL=$kernel_dev/lib/modules/$kernelVersion/build

    cp $BUILT_KERNEL/Module.symvers .
    cat $BUILT_KERNEL/.config > .config
    cp $kernel_dev/vmlinux .

    ./scripts/config --module CONFIG_JOYSTICK_NINTENDO_SWITCH2_USB

    make "-j$NIX_BUILD_CORES" modules_prepare
    make "-j$NIX_BUILD_CORES" M="drivers/hid" hid-nintendo.ko
    make "-j$NIX_BUILD_CORES" M="drivers/input/joystick" KBUILD_EXTRA_SYMBOLS="../../hid/Module.symvers" nintendo-switch2-usb.ko
  '';

  installPhase = ''
    runHook preInstall

    xz -z -f drivers/hid/hid-nintendo.ko
    xz -z -f drivers/input/joystick/nintendo-switch2-usb.ko

    install -Dm444 drivers/hid/hid-nintendo.ko.xz $out/lib/modules/$kernelVersion/updates/hid-nintendo.ko.xz
    install -Dm444 drivers/input/joystick/nintendo-switch2-usb.ko.xz $out/lib/modules/$kernelVersion/updates/nintendo-switch2-usb.ko.xz

    runHook postInstall
  '';
}
