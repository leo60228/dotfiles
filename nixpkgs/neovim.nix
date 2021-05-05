self: super: rec {
  tree-sitter = self.callPackage ../tree-sitter {
    inherit (self.darwin.apple_sdk.frameworks) Security;
  };

  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "nightly";
    src = self.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "4ad30f775e5564c539324b4818886f067d2ecd99";
      sha256 = "1yr95wia1rfz0p4c2krhgz5rp0rvnmfpbwp3l31gfd27vx6xin2x";
      fetchSubmodules = true;
    };
    buildInputs = oldAttrs.buildInputs ++ [ tree-sitter ];
  });
}
