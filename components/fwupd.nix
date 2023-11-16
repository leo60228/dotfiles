let lib = import ../lib; in
lib.makeComponent "fwupd"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    services.fwupd.enable = true;
    services.packagekit.enable = true;
    environment.systemPackages = with pkgs; [ plasma5Packages.discover ];
    environment.etc."fwupd/remotes.d/lvfs-testing.conf" = lib.mkForce {
      text = ''
[fwupd Remote]

# this remote provides metadata and firmware marked as 'testing' from the LVFS
Enabled=true
Title=Linux Vendor Firmware Service (testing)
MetadataURI=https://cdn.fwupd.org/downloads/firmware-testing.xml.gz
ReportURI=https://fwupd.org/lvfs/firmware/report
#Username=
#Password=
OrderBefore=lvfs,fwupd
AutomaticReports=false
ApprovalRequired=false
      '';
    };
  };
})
