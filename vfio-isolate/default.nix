{ src, poetry2nix }:
poetry2nix.mkPoetryApplication {
  inherit src;
  projectDir = src;
  pyproject = ./pyproject.toml;
  poetrylock = ./poetry.lock;
}
