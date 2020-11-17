self: super: rec {
  tree-sitter = self.callPackage ../tree-sitter {
    inherit (self.darwin.apple_sdk.frameworks) Security;
  };

  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "nightly";
    src = self.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "8c4648421a1e34c3e95e42ea596de36987f02563";
      sha256 = "119kds8a0l557aapzkgmp9c1c7zqxi9h6yia20yjk88ibx7bswkv";
      fetchSubmodules = true;
    };
    buildInputs = oldAttrs.buildInputs ++ [ tree-sitter ];
  });
}
