self: super:

{
  nginxMainline = super.nginxMainline.override {
    openssl = self.aws-lc.override {
      symbolPrefix = null;
      withOpenSSLShim = true;
    };
  };
}
