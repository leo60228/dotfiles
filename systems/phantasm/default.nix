{
  config,
  pkgs,
  flakes,
  ...
}:

{
  imports = [ flakes.nixos-wsl.nixosModules.default ];

  system.stateVersion = "25.05";

  wsl = {
    enable = true;
    defaultUser = "leo60228";
    interop = {
      register = true;
      includePath = false;
    };
  };

  services.resolved.enable = false;

  deployment.allowLocalDeployment = true;

  home-manager.users.leo60228.home.packages = [ pkgs.colmena ];
}
