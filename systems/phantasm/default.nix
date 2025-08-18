{
  config,
  pkgs,
  flakes,
  ...
}:

{
  imports = [ flakes.nixos-wsl.nixosModules.default ];

  system.stateVersion = "25.05";

  wsl.enable = true;
  wsl.defaultUser = "leo60228";

  deployment.allowLocalDeployment = true;
}
