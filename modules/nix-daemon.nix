{ ... }:
{
  config = {
    nix.extraOptions = ''
      warn-dirty = false
    '';
  };
}
