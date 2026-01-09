{
  pyproject-nix,
  uv2nix,
  pyproject-build-systems,
  ...
}:
self: super: { inherit pyproject-nix uv2nix pyproject-build-systems; }
