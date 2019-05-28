let lib = import ../lib; in
lib.makeComponent "vfio"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    # libvirt
    virtualisation.libvirtd.enable = true;
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
    '';
    environment.systemPackages = [ pkgs.virtmanager pkgs.OVMF ];
    boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];
    boot.extraModprobeConfig = ''
      options vfio-pci ids=10de:1c02,10de:10f1
    '';
    boot.postBootCommands = ''
      DEVS="0000:01:00.0 0000:01:00.1"

      for DEV in $DEVS; do
        echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
      done

      modprobe -i vfio-pci
    '';
    boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];
    boot.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];
    boot.blacklistedKernelModules = [ "nouveau" ];
    users.groups.libvirtd.members = [ "root" "leo60228" ];
  };
})
