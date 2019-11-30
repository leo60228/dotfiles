let lib = import ../lib; in
lib.makeComponent "en_us"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    # Select internationalisation properties.
    i18n = lib.mkDefault {
      consoleFont = "Lat2-Terminus16";
      consoleKeyMap = "us";
      defaultLocale = "en_US.UTF-8";
    };
    environment.systemPackages = with pkgs; [
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
    ];
    environment.etc."/etc/aspell.conf".text = ''
    master en_US
    extra-dicts en-computers.rws
    add-extra-dicts en_US-science.rws
    '';
  };
})
