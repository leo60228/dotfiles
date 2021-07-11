let lib = import ../lib; in
lib.makeComponent "wg"
({config, pkgs, lib, ...}: with lib; {
  opts = {};

  config = {
    networking.wireguard.interfaces = {
      wg0 = let
	p2p = import ../p2p/peers.nix pkgs;
	inherit (config.networking) hostName;
	host = p2p.hosts.${hostName};
      in host;

    networking.firewall.trustedInterfaces = [ "wg0" ];
    };
  };
})
