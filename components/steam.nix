let lib = import ../lib; in
lib.makeComponent "steam"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    # Steam
    hardware.opengl.driSupport32Bit = true;
    hardware.pulseaudio.support32Bit = true;
    environment.systemPackages = [ ((pkgs.newScope pkgs.steamPackages) ../steam-chrootenv.nix {
      glxinfo-i686 = pkgs.pkgsi686Linux.glxinfo;
      steam-runtime-wrapped-i686 =
        if pkgs.stdenv.hostPlatform.system == "x86_64-linux"
        then pkgs.pkgsi686Linux.steamPackages.steam-runtime-wrapped
        else null;
    }) ];

    services.udev.extraRules = ''
  # This rule is needed for basic functionality of the controller in Steam and keyboard/mouse emulation
  SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"

  # This rule is necessary for gamepad emulation; make sure you replace 'pgriffais' with a group that the user that runs Steam belongs to
  KERNEL=="uinput", MODE="0660", GROUP="leo60228", OPTIONS+="static_node=uinput"

  # Valve HID devices over USB hidraw
  KERNEL=="hidraw*", ATTRS{idVendor}=="28de", MODE="0666"

  # Valve HID devices over bluetooth hidraw
  KERNEL=="hidraw*", KERNELS=="*28DE:*", MODE="0666"

  # DualShock 4 over USB hidraw
  KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"

  # DualShock 4 wireless adapter over USB hidraw
  KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0666"

  # DualShock 4 Slim over USB hidraw
  KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"

  # DualShock 4 over bluetooth hidraw
  KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0666"

  # DualShock 4 Slim over bluetooth hidraw
  KERNEL=="hidraw*", KERNELS=="*054C:09CC*", MODE="0666"

  # Switch Hack
  SUBSYSTEM=="usb", ATTR{idVendor}=="0955", MODE="0664", GROUP="plugdev"
    '';
  };
})
