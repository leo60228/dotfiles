self: super: {
  qt6Packages = super.qt6Packages.overrideScope (
    self': super': {
      libquotient = super'.libquotient.overrideAttrs (oldAttrs: rec {
        version =
          assert oldAttrs.version == "0.9.1";
          "0.9.5";

        src = self.fetchFromGitHub {
          owner = "quotient-im";
          repo = "libQuotient";
          tag = version;
          hash = "sha256-wdIE5LI4l3WUvpGfoJBL8sjBl2k8NfZTh9CjfJc9FIA=";
        };

        patches = [
          # Fix use of libquotient by library consumers like NeoChat;
          # without this (upstreamed) patch, consumers will fail to
          # build when trying to link to Qt6::CorePrivate.
          # Remove when bumping package version.
          (self.fetchpatch {
            url = "https://github.com/quotient-im/libQuotient/commit/6d5a80ddaab5803c318240c7978a16fbdc36bb34.patch";
            hash = "sha256-JMdcywGgZ0Gev/Nce4oPiMJQxTBJYPoq+WoT3WLWWNQ=";
          })
        ];

        cmakeFlags = [ ];
      });
    }
  );
}
