name: component: { pkgs, config, lib, ... }@args:
let called = component (args // {
  cfg = args.config.components.config.${name};
}); in {
  options = {
    components.config.${name} = called.opts;
    components.enabled.${name} = args.lib.mkOption {
      default = false;
      type = args.lib.types.bool;
    };
  };
  config = args.lib.mkIf args.config.components.enabled.${name} called.config;
}
