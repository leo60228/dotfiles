{ pkgs, ... }:

{
  users.extraUsers.leo60228 = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keyFiles = [ /home/leo60228/.ssh/id_rsa.pub ];
  };
  
  users.users.root.openssh.authorizedKeys.keyFiles = [ /home/leo60228/.ssh/id_rsa.pub ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
  
  nixpkgs.config.allowUnfree = true;

  # trusted users
  nix.trustedUsers = [ "root" "@wheel" ];
  
  environment.systemPackages = with pkgs; [
    openssh
  ];

  services.openssh.enable = true;
}