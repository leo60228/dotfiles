let lib = import ../lib; in
lib.makeComponent "vfio"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    virtualisation.libvirtd.qemuVerbatimConfig = ''
      namespaces = []
      cgroup_device_acl = [
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom",
          "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
          "/dev/rtc","/dev/hpet",
          "/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse",
          "/dev/input/event_m570",
          "/dev/input/by-id/usb-LEOPOLD_Mini_Keyboard-event-kbd",
          "/dev/input/by-id/usb-04d9_USB_Keyboard-event-kbd",
      ]
      nographics_allow_host_audio = 1
      user = "leo60228"
    '';
    services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c52b", MODE="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0853", ATTRS{idProduct}=="0134", MODE="0666"
    '';
    #boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];
    boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];
    boot.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];
    boot.blacklistedKernelModules = [ "nouveau" ];
    hardware.pulseaudio.extraConfig = ''
        load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
    '';
    hardware.pulseaudio.extraClientConf = ''
        default-server = 127.0.0.1
    '';
    systemd.services.libvirtd.preStart = let qemuHookFile = ../files/vfio-qemu-hook; in ''
    mkdir -p /var/lib/libvirt/hooks
    chown -R leo60228:users /var/lib/libvirt
    chmod 755 /var/lib/libvirt/hooks

    # Copy hook files
    cp -f ${qemuHookFile} /var/lib/libvirt/hooks/qemu

    # Make them executable
    chmod +x /var/lib/libvirt/hooks/qemu
    '';
  };
})
