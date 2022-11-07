{ pkgs, ... }: with import ../components; rec {
  components = en_us efi est server tailscale;

  boot.cleanTmpDir = true;
}
