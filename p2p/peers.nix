{ writeTextFile, lib, ... }:

let
  metadata = builtins.fromTOML (builtins.readFile ./hosts.toml);
  roamPeer = { network, wireguard, ... }:
    let
      net = metadata.networks."${network}";
      extraAddrs = ({ extra_addrs ? [ ], ... }: extra_addrs) wireguard;
    in {
      allowedIPs = [
        "${wireguard.addrs.v4}/32"
      ] ++ extraAddrs;
      publicKey = wireguard.pubkey;
    };
  serverPeer = { network, wireguard, ip_addr, ... }:
    let
      net = metadata.networks."${network}";
      extraAddrs = ({ extra_addrs ? [ ], ... }: extra_addrs) wireguard;
    in {
      allowedIPs = [
        "${wireguard.addrs.v4}/32"
      ] ++ (if wireguard.addrs.v4 == "10.100.0.1" then [ "10.100.0.0/24" ] else [ ])
        ++ extraAddrs;
      publicKey = wireguard.pubkey;
      persistentKeepalive = 25;
      endpoint = "${ip_addr}:${toString wireguard.port}";
    };
  interfaceInfo = { network, wireguard, ... }:
    peers:
    let
      net = metadata.networks."${network}";
    in {
      ips = [
        "${wireguard.addrs.v4}/32"
      ];
      privateKeyFile = "/root/wireguard-keys/private";
      listenPort = wireguard.port;
      inherit peers;
    };
in with metadata.hosts; rec {
  # expected peer lists
  mesh = [
    (roamPeer desktop)
    (serverPeer prometheus)
  ];

  hosts = {
    desktop = interfaceInfo desktop mesh;
    prometheus = interfaceInfo prometheus mesh;
  };
}
