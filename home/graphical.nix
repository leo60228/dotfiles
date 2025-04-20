{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.vris.graphical {

}
