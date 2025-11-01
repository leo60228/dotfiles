self: super:

{
  cantata = super.cantata.overrideAttrs (oldAttrs: {
    env.NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations -Wno-error=unused-result";
  });
}
