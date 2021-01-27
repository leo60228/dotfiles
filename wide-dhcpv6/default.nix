{ stdenv, fetchurl, yacc, flex, autoreconfHook }:
stdenv.mkDerivation {
    pname = "wide-dhcpv6";
    version = "20080615-23";

    nativeBuildInputs = [ yacc flex autoreconfHook ];
    buildInputs = [ flex ];

    patches = [
        ./patches/no-user-group.patch
        ./patches/0001-Fix-manpages.patch
        ./patches/0002-Don-t-strip-binaries.patch
        ./patches/0003-Close-inherited-file-descriptors.patch
        ./patches/0004-GNU-libc6-fixes.patch
        ./patches/0005-Update-ifid-on-interface-restart.patch
        ./patches/0006-Add-new-feature-dhcp6c-profiles.patch
        ./patches/0007-Adding-ifid-option-to-the-dhcp6c.conf-prefix-interfa.patch
        ./patches/0008-Close-file-descriptors-on-exec.patch
        ./patches/0009-Fix-renewal-of-IA-NA.patch
        ./patches/0010-Call-client-script-after-interfaces-have-been-update.patch
        ./patches/0011-resolv-warnings-so-as-to-make-blhc-and-gcc-both-happ.patch
        ./patches/0012-fix-a-redefined-YYDEBUG-warning-of-gcc-for-the-code-.patch
        ./patches/0013-added-several-comments-examples-by-Stefan-Sperling.patch
        ./patches/0014-Support-to-build-on-kFreeBSD-n-GNU-Hurd-platform.patch
        ./patches/0015-a-bit-info-to-logger-when-get-OPTION_RECONF_ACCEPT.patch
        ./patches/0016-fix-typo-in-dhcp6c.8-manpage.patch
        ./patches/0017-Remove-unused-linking-with-libfl.patch
        ./patches/0018-dhcpv6-ignore-advertise-messages-with-none-of-reques.patch
        ./patches/0019-Server-should-not-bind-control-port-if-there-is-no-s.patch
        ./patches/0020-Adding-option-to-randomize-interface-id.patch
        ./patches/0021-Make-sla-len-config-optional.patch
        ./patches/0022-Make-sla-id-config-optional.patch
        ./patches/ifid-high.patch
    ];

    src = fetchurl {
        url = "mirror://sourceforge/wide-dhcpv6/wide-dhcpv6-20080615.tar.gz";
        sha256 = "10dxs5zshr6ljxdyjv2mi9qn62wfzwzwp0wv0a8bvspdl5s639jm";
    };
}
