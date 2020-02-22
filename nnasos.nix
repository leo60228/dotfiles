{ buildFHSUserEnv }:
buildFHSUserEnv {
    name = "nNASOS";
    targetPkgs = pkgs: with pkgs; [ openssl_1_0_2 ];
    runScript = "${./files/nNASOS}";
}
