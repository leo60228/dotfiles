self: super:

{
  nginx = self.nginxMainline;
  nginxMainline = super.nginxMainline.override { openssl = self.aws-lc; };
}
