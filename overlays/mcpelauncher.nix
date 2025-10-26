self: super: {
  mcpelauncher-client = super.mcpelauncher-client.overrideAttrs (oldAttrs: {
    cmakeFlags = oldAttrs.cmakeFlags ++ [ (self.lib.cmakeBool "USE_SDL3_AUDIO" true) ];
  });

  mcpelauncher-ui-qt = super.mcpelauncher-ui-qt.overrideAttrs (oldAttrs: {
    preFixup = ''
      ${oldAttrs.preFixup}
      qtWrapperArgs+=(
        --suffix LD_LIBRARY_PATH : "${
          self.lib.makeLibraryPath [
            self.alsa-lib
            self.pulseaudio
            self.pipewire
          ]
        }"
      )
    '';
  });
}
