{
  nixos = { pkgs, lib, modulesPath, ... }: {
    imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  };

  system = "aarch64-linux";
}
