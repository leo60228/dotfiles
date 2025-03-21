{ callPackage }:
{
  nvim-echo-diagnostics = callPackage ./nvim-echo-diagnostics.nix { };
  omnisharp-vim = callPackage ./omnisharp-vim.nix { };
  vim-poryscript = callPackage ./vim-poryscript.nix { };
}
