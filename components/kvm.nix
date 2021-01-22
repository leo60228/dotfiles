let lib = import ../lib; in
lib.makeComponent "kvm"
({cfg, config, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    # libvirt
    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.onBoot = "ignore";
    virtualisation.libvirtd.onShutdown = "shutdown";
    virtualisation.libvirtd.qemuPackage = pkgs.qemu_kvm.overrideAttrs (oldAttrs: {
      postPatch = ''
      qemu_hd_replacement="WDC WD20EARS"
      qemu_dvd_replacement="DVD-ROM"
      hypervisor_string_replacement="\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0\\0"
      echo "VM detection patch..."
      sed -i "s/QEMU HARDDISK/$qemu_hd_replacement/g" hw/ide/core.c
      sed -i "s/QEMU HARDDISK/$qemu_hd_replacement/g" hw/scsi/scsi-disk.c
      sed -i "s/QEMU DVD-ROM/$qemu_dvd_replacement/g" hw/ide/core.c
      sed -i "s/QEMU DVD-ROM/$qemu_dvd_replacement/g" hw/ide/atapi.c
      sed -i "s/QEMU PenPartner tablet/<WOOT> PenPartner tablet/g" hw/usb/dev-wacom.c
      sed -i 's/s->vendor = g_strdup("QEMU");/s->vendor = g_strdup("<WOOT>");/g' hw/scsi/scsi-disk.c
      sed -i "s/QEMU CD-ROM/$qemu_dvd_replacement/g" hw/scsi/scsi-disk.c
      sed -i 's/padstr8(buf + 8, 8, "QEMU");/padstr8(buf + 8, 8, "<WOOT>");/g' hw/ide/atapi.c
      sed -i 's/QEMU MICRODRIVE/<WOOT> MICRODRIVE/g' hw/ide/core.c
      sed -i "s/KVMKVMKVM\\0\\0\\0/$hypervisor_string_replacement/g" target/i386/kvm.c
      sed -i 's/"bochs"/"<WOOT>"/g' block/bochs.c
      sed -i 's/"BOCHS "/"ALASKA"/g' include/hw/acpi/aml-build.h
      sed -i 's/Microsoft Hv/$hypervisor_string_replacement/g' target/i386/kvm.c
      echo "Applied!"
      '';
    });
    environment.systemPackages = with pkgs; [ OVMF config.virtualisation.libvirtd.qemuPackage virt-manager ];
    users.groups.libvirtd.members = [ "root" "leo60228" ];
    systemd.services.libvirtd.path = with pkgs; [ bash killall libvirt kmod vfio-isolate ];
  };
})
