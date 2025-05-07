{
  config,
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

  vris.firefox =
    let
      wrapFirefox = pkgs.wrapFirefox.override {
        ffmpeg = pkgs.ffmpeg.overrideAttrs (oldAttrs: {
          patches = oldAttrs.patches ++ [
            (pkgs.fetchpatch {
              url = "https://raw.githubusercontent.com/LibreELEC/LibreELEC.tv/dbbb3cb45a2dbbe1f75006073f353a4f4de94bca/packages/multimedia/ffmpeg/patches/v4l2-drmprime/ffmpeg-001-v4l2-drmprime.patch";
              hash = "sha256-7pd8M5mADYVjuXoJZ7gNJs6JSi6yFgpZq93YlWNlmck=";
            })
          ];
        });
      };
    in
    wrapFirefox (flakes.flake-firefox-nightly.overlays.default pkgs pkgs).firefox-nightly-bin.unwrapped
      { pname = "firefox-nightly-bin"; };
}
