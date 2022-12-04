self: super: {
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "nightly";
    src = self.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "b098e7971fdf8ed3f7d0c52aff0ce126c34ff3c8";
      sha256 = "u2dliJyyKL/Ff16JKojWB8s7N7/s+RMQtsKHMq+jRZ4=";
      fetchSubmodules = true;
    };
    buildInputs = oldAttrs.buildInputs ++ [ self.tree-sitter ];
  });
}
