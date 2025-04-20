{
  pkgs,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ "${modulesPath}/virtualisation/amazon-image.nix" ];
  systemd.services.amazon-init.enable = lib.mkForce false;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDYYsVZc4wkyT3ZE/f0/1aIXPFjl+XSxUsLGIE2p+B1kQ0hvrz6+d7u7Vvk6GIqI1+n6CEgNOgLKJQgiTy3A+Davotpg6cr4fTMAkOO1rXQWqCKAixy/TgXziBxTV6Jd5GcBnVl8hVQur8jAht1d041zpF51mIUpc2H6eQOi0aM8Xgw3QD5v7zKvZRQuwivk4hU5aNVIQW8Cd5TN7QJWR5/U51I613c5kw2QRRfGedl9TY0S7bhs38GTp0mzGdOllph3kW3BryIabeyvEbLaSwL3J6gY1d/vEuSGaiUTsdjgELQV4OdId/oqA4UrGK4ky/G/WiovSQjhB7mTgXc9RELyscrlRiByhSa0nLWW1S1bE936e1CMPWxHVcN0bMana1ckCGgBILYldus1G2EakQLhOi+gcSz/uBEDybyZ+U2odloep2Q2TpKC1IX5Uq6y8MAUmxuIUfn2U3kHrZvqQoYaQEHu35kHldOU48GBl84zSE9Jho/mXjZZOJYmqk89kXkjm5IjEHsF/l0GKz/HtWLkdSXek0Yy1JRN+HI00iyYb/ILCGGlcCznzY56emCAwN8PRCa5AvyC5lCfCm/SiE7VNqRK21eH/X1cbAS1g/Yx+NTstFH+3lEj4H/UP7We0N3+lc0vteh88sriuHgLYylnJA0DFL0ptteLCo9TeeAmQ== cardno:000608752585"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5J4O4+FGHXbYmxFmWEbhb0e96hHjvj4d5MukVcpZuF2nnems4FfkqZzb2J+PUCYpnFjz6lQFGl2SgrnMmWhQExzXK7hDR9F5UJhdDaE/GI4QbywtDV6gmTFftW/giNSWlGHGrdDsIrKUaROHfzq+l35KwdItHnpV8KNXkvw/O4qJDpkl2rKHHBGx/huWNKtUmoZSYBV6s+Lfr1w4j4DUdbUHD4fk1d7RXwHgcu51uN2qVSxMJhtX+9xw7xSgoYsaLDb+U+21i+3equmTHHYbjuAX5/RZZmy/JThXXxlvNytdCbjF3vxa6EijX7NjS6Y+5BX9Am3E2JFjea15Ck3fr /home/leo60228/.ssh/id_rsa"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC45kfim92fZPMEsX1lIlkzN5455SDT7gyICx/nNYfe4wJcOoyJYbbbFAnnD/M47NjRW4vaQ1CgNFahsCbpZacCR0GGPzdwlGfLXxkjhrkHj8qGEeDqq47rvSYCIHgviclOIAPh6pZh+KSRSQQqFp63rYZwqa3zWsz8HT+yiVJkccwJnm6HQbncA5ctbkJ5qt/qZrKyPXj421YjGxuxSpZdpg+v960lUcSkLyseXU9QmS32CU8bH1wFaBdAlI1VJSO1Vx5Z7B8Z4LbtFizvBy+VRuQDARJUKhQyY+RWnAMbFC9cJy7ge6FsrLfX4+dYh2CJssDPUG4uUsXLdBYV6QZr root@digitaleo"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9YgtqLs76ZQHml8rzwRzJgR1xWmeBAZ+NTXCX3UQ63vmKOYCzQn5WbDiKxs5dIPq1cFYHMnx2QstGYmRyAS8DCyhGYciu8BIXG/4lswWmheOhuQDM2sEgqZSOUekf5W+f9fxvkZwem7oZfTJk/WGs0junbCpvTl/lFZts8qX7osyhHQ4AtbUKzj9vwsAukwgzzGXAUhT9+Fqs9j4lWmRJGRH4lN0wvsAXpufLR5GAjS0IWazo/xleMVSz8AOYY0kA8yn5TzQq5RAuN6zUE8LiIFBrO0QKiTIwpXGj7FF7+ULFXYTHy8AwsagN5Fn6HWMKqAWaLwh7RtKGzhQAmx1n leo60228@digitaleo"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPBGeYEbAh7SLuTQCQ7i+W2ssiONuGkPMtZmQ7z986lKhR0uTTBblsuhAyQ3wN9Zn94cVLNlzTkseMo9ZZtCzpyqZ7FrQxnEQUX3Q3gKMkBhgpj06Gh9sqODoqRhstEWLdvwYHA+yYEFSxrbww5pZQrSmN1o/adscN9nYRIJGB6Oe4sUj/nkAcrdeTCbAV7SwKTNQSkks1ZDzFvMEO7kfLUm9X6gaINWPOiyEGVlVFVSG8o8ZE1uNUC/2ZtITYHaWgX5TIGHHJPXYQrt9A4cDgX2AMjWqvYKhmrsSfVtSZyrQC9S0ZSe7GDRdUuaYBjYFds5w3AbCATjtG7NncmK1B leo60228@DESKTOP-NBAEBEJ"
  ];

  systemd.services.NetworkManager-wait-online.enable = false;

  swapDevices = [
    {
      device = "/var/swapfile";
      size = 4096;
    }
  ];

  boot.loader.grub.device = lib.mkForce "/dev/nvme0n1";

  deployment.tags = [ "servers" ];
}
