self: super: rec {
  tree-sitter = self.callPackage ../tree-sitter {
    inherit (self.darwin.apple_sdk.frameworks) Security;
  };

  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "nightly";
    src = self.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "3e1ef185793418f50893c6026b0d1966323d279b";
      sha256 = "BN7r5v6YpDrIgg5bp9RlQLikp4I8jE+5eofcyvUqkJw=";
      fetchSubmodules = true;
    };
    buildInputs = oldAttrs.buildInputs ++ [ tree-sitter ];
  });
}
