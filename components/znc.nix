let lib = import ../lib; in
lib.makeComponent "znc"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    services.znc = {
      enable = true;
      mutable = true;
      useLegacyConfig = false;
      openFirewall = true;
      #config = {
      #  LoadModule = [ "adminlog" "webadmin" ];
      #  User.leo60228 = {
      #    Admin = true;
      #    Pass.password = builtins.fromJSON (builtins.readFile ../secrets/znc.json);
      #  };
      #};
    };
  };
})
