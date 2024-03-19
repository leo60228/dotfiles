self: super:

{
    nginx = super.nginx.override { openssl = self.boringssl; };
    nginxStable = super.nginxStable.override { openssl = self.boringssl; };
    nginxMainline = super.nginxMainline.override { openssl = self.boringssl; };
}
