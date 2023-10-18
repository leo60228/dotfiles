self: super:

{
    ares = super.ares.overrideAttrs (oldAttrs: {
        postFixup = ''
        wrapProgram $out/bin/ares \
            --set LD_LIBRARY_PATH ${self.lib.makeLibraryPath [ self.vulkan-loader ]}
        '';
    });
}
