self: super:

let
  override =
    nginx:
    (nginx.override { openssl = self.boringssl; }).overrideAttrs (oldAttrs: {
      NIX_LDFLAGS = [ "-lstdc++" ]; # i hate it here
    });
in
{
  nginx = override super.nginx;
  nginxStable = override super.nginxStable;
  nginxMainline = override super.nginxMainline;
}
