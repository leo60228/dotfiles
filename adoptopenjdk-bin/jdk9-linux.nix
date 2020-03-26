let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
in
  import ./jdk-linux-base.nix sources.openjdk9.linux.jdk.hotspot
