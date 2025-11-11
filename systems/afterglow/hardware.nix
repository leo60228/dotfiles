{
  lib,
  pkgs,
  flakes,
  ...
}:
{
  imports = [
    (import "${flakes.mobile-nixos}/lib/configuration.nix" { device = "lenovo-homestar"; })
  ];

  networking.firewall.checkReversePath = lib.mkForce false;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c85a48fa-bd42-4e20-993b-5ed87e8548f3";
    fsType = "ext4";
  };

  boot.growPartition = false;

  boot.initrd.luks.devices."lvm".device = "/dev/disk/by-uuid/6e45bd62-0f61-471b-8e08-cf0545b4f606";

  zramSwap.enable = true;

  hardware.firmware = [ pkgs.chromeos-sc7180-unredistributable-firmware ];
  mobile.boot.stage-1.kernel.useNixOSKernel = true;

  vris.firefox =
    let
      wrapFirefox = pkgs.wrapFirefox.override {
        ffmpeg = pkgs.ffmpeg.overrideAttrs (oldAttrs: {
          patches = oldAttrs.patches ++ [
            (pkgs.fetchpatch {
              url = "https://raw.githubusercontent.com/LibreELEC/LibreELEC.tv/9c99ad0f0bdad077176be4250e64e9deda70c062/packages/multimedia/ffmpeg/patches/rpi/ffmpeg-001-rpi.patch";
              hash = "sha256-IZsRZ25UUTvuSeXGGNJ8TODU51EO8rmAfjdsRPA9O5M=";
            })
          ];
          doCheck = false;
        });
      };
    in
    wrapFirefox (flakes.flake-firefox-nightly.overlays.default pkgs pkgs).firefox-nightly-bin.unwrapped
      { pname = "firefox-nightly-bin"; };
}
