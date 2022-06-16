self: super: {
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "nightly";
    src = self.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "aa35d15a0db8a5a2a0b06aca7b7161c5e35b57b1";
      sha256 = "WNWHTIAK6LVimNwTZr6k7/BQ5MNjFmrVDBhM7/8v6Rw=";
      fetchSubmodules = true;
    };
    buildInputs = oldAttrs.buildInputs ++ [ self.tree-sitter ];
  });
}
