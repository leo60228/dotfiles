self: super: {
  lua-language-server = super.lua-language-server.overrideAttrs (oldAttrs: rec {
    version =
      assert oldAttrs.version == "3.17.1";
      "3.16.4";

    src = self.fetchFromGitHub {
      owner = "luals";
      repo = "lua-language-server";
      tag = version;
      hash = "sha256-5dBAxxtVtJXuS9CQj3IoxSKTdChxQhGjRitxydLna00=";
      fetchSubmodules = true;
    };
  });
}
