{ callPackage }:
{
  nvim-echo-diagnostics = callPackage ./nvim-echo-diagnostics.nix { };
  vim-poryscript = callPackage ./vim-poryscript.nix { };
  jupytext-nvim = callPackage ./jupytext-nvim.nix { };
}
