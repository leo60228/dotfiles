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
  boot.kernelPackages = pkgs.linuxPackages_6_18;
  boot.initrd.includeDefaultModules = true;
  boot.initrd.availableKernelModules = [
    "hid_google_hammer"

    # A whole bunch of CrOS EC drivers
    "extcon_usbc_cros_ec"
    "i2c_cros_ec_tunnel"
    "cros_ec_lid_angle"
    "cros_ec_sensors_core"
    "cros_ec_sensors"
    "cros_ec_keyb"
    "cros_ec_dev"
    "cros_ec_chardev"
    "cros_ec_i2c"
    "cros_ec"
    "cros_ec_rpmsg"
    "cros_ec_sensorhub"
    "cros_ec_spi"
    "cros_ec_sysfs"
    "cros_ec_typec"
    "cros_ec_vbc"
    "cros_usbpd_notify"
    "cros_usbpd_charger"
    "pwm_cros_ec"
    "cros_ec_regulator"
    "rtc_cros_ec"
    "snd_soc_cros_ec_codec"

    # from nixos-mobile
    "sbs-battery"
    "sbs-charger"
    "sbs-manager"

    "msm"
    "coreboot_table"

    "panel_boe_tv101wum_nl6"

    "snd_soc_sc7180"
    "dispcc_sc7180"
    "camcc_sc7180"
    "videocc_sc7180"
    "snd_soc_lpass_sc7180"
    "lpasscorecc_sc7180"
    "gpucc_sc7180"
  ];

  vris.firefox =
    let
      wrapFirefox = pkgs.wrapFirefox.override {
        ffmpeg_7 = pkgs.ffmpeg_7.overrideAttrs (oldAttrs: {
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
