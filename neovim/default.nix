{ neovim, python3, vimPlugins, callPackage, lib }:
let ftPlugins = with vimPlugins; [
        { plug = vim-nix; ft = "nix"; }
    ];
    plugins = builtins.attrNames (builtins.readDir ./vimrc.d);
in neovim.override {
    vimAlias = true;

    configure = {
        customRC = builtins.readFile ./vimrc
            + "\n\" Filetype plugins (autogenerated) {{{\n"
            + lib.concatMapStrings (x:
                "autocmd FileType ${x.ft} :packadd ${x.plug.pname}\n"
            ) ftPlugins
            + "\" }}}\n\n\" vimrc.d/ contents:\n\n" + lib.concatMapStrings (x:
                "\" ${x}\n${(builtins.readFile (./vimrc.d + "/${x}"))}\n\n"
            ) plugins;

        packages.leovim = with vimPlugins; {
            start = [ vim-hardtime (callPackage ./solarized8.nix {}) ];

            opt = []
                ++ map (x: x.plug) ftPlugins;
        };
    };
}