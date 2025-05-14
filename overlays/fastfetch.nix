self: super:

{
  fastfetch = super.fastfetch.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ self.libdrm ];
    cmakeFlags = oldAttrs.cmakeFlags ++ [
      (self.lib.cmakeBool "ENABLE_DRM" true)
      (self.lib.cmakeBool "ENABLE_DRM_AMDGPU" true)
    ];
  });
}
