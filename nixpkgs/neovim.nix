self: super: {
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (oldAttrs: {
    version = "nightly";
    src = self.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "161efc9ea48afdd24015ecfc25a55de977bbac3a";
      sha256 = "rcwdf4RF3BxgmuSUJ+D/jrmmUIp4Olyl8PcMjEhs958=";
      fetchSubmodules = true;
    };
    buildInputs = oldAttrs.buildInputs ++ [ self.tree-sitter ];
  });
}
