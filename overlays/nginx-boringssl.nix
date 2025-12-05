self: super:

{
  nginxMainline = super.nginxMainline.override { openssl = self.aws-lc; };
}
