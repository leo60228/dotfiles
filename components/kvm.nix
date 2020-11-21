let lib = import ../lib; in
lib.makeComponent "kvm"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    # libvirt
    virtualisation.libvirtd.enable = true;
    virtualisation.libvirtd.onBoot = "ignore";
    virtualisation.libvirtd.onShutdown = "shutdown";
    environment.systemPackages = [ pkgs.virtmanager pkgs.OVMF ];
    users.groups.libvirtd.members = [ "root" "leo60228" ];
    systemd.services.libvirtd.path = with pkgs; [ bash killall libvirt kmod ];
  };
})
