let lib = import ../lib; in
lib.makeComponent "macvm"
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
      nographics_allow_host_audio = 1
    '';
    environment.systemPackages = with pkgs; [ virtmanager qemu_kvm dmg2img git wget libguestfs tunctl ];
    boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];
    boot.initrd.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];
    boot.kernelModules = [ "vfio_pci" "vfio" "vfio_iommu_type1" "vfio_virqfd" ];
    users.groups.libvirtd.members = [ "root" "leo60228" ];
    hardware.pulseaudio.extraConfig = ''
        load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1
    '';
    hardware.pulseaudio.extraClientConf = ''
        default-server = 127.0.0.1
    '';
  };
})
