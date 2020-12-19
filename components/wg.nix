let lib = import ../lib; in
lib.makeComponent "wg"
({cfg, pkgs, lib, ...}: with lib; {
  opts = {
    ip = mkOption {
      type = types.str;
    };
  };

  config = {
    networking.wireguard.interfaces = {
      wg0 = {
	ips = [ "${cfg.ip}/24" ];

	privateKeyFile = "/home/leo60228/wireguard-keys/private";

	peers = [
	  {
	    publicKey = "R19IME8fMBp2/FOKzEWnECn1yMyWjPsZNXaD6q0jTTc=";
	    allowedIPs = [ "10.100.0.0/24" ];
	    endpoint = "68.183.115.15:51820";
	    persistentKeepalive = 25;
	  }
	];
      };
    };
  };
})
