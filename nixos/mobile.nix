{
  config,
  lib,
  ...
}:

{
  options = {
    vris.mobile = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf config.vris.mobile {
    services.geoclue2 = {
      enable = true;
      enableModemGPS = false;
      enableCDMA = false;
      enable3G = false;
    };

    time.timeZone = null;
  };
}
