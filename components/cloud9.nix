let
  lib = import ../lib;
in
lib.makeComponent "cloud9" (
  {
    cfg,
    pkgs,
    lib,
    ...
  }:
  with lib;
  {
    opts = { };

    config = {
      security.sudo.extraRules = [
        {
          users = [ "cloud9" ];
          commands = [
            {
              command = "ALL";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];

      users.users.cloud9 = {
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDe8czPcC6Exze9aeYlYvH+l5JmOZLdPhaZdtWqA30IQgsX0cWqyxxVCLz5DGZKt81rKexAGJ3l4hUuPP3Y8PQnlR8FbXv2LBVzg3A6MtVrMMwIcgvNFqq+SK23ElGMTB7yaWa/PlP4GoTNPvxFHu/Uu0XiMNc+Mois7CsQZd2Bbw7ANrAUb1Kzq43SImwRLXiU7cdSImL64d4ZpQ8qN716ZTeI+3RJu9wv7xxhoe8MmGOtL5FIG0zC67L1wz8P0UsLlZrGXNpOBKNht23YI9XaMIDGlCwBdMsVSVy8CG0vqhh67AtfeetyGjYzhggi0ot7IEQM8ZIv1H1AyUurnrk17qnxQ8VoAN+8u/IPWdINR8hqiGfTwYLla+4L2uNSmIQnn6axkAUL5NZcmvkiyWWxniap3sG/+NFiFbCcgOCVj7zFLGXPB+TZhMN9TVah1uBYq++BIFVjd6O+d4fnD6sS9HAr/+iGjDSyzORKuMXDJ9seRdM56mlzelSUXum9jFxbT6k2qe+Oyxi8xnWlTJ93zlyL9dlxAEYdeX9/w51enJ1cC9AYp/n0O6S+XHnLIn1vU4DUUWZ4bl/rEUzy5rKPwb9F78ccGYjN0xrP5AjqPqVU628+6gzxwXkl5HNITBX7E9L1N0RegSe02pHE+1yLD4Bh4jX1ovr2/+Eq5uAi4Q== root+171102507141@cloud9.amazon.com"
        ];
        uid = 456;
        isSystemUser = true;
        shell = "${pkgs.writeScriptBin "c9shell.sh" ''
          #!${pkgs.bash}/bin/bash
          if [ "$UID" -ne "456" ]; then
            exit 1
          fi
          COMMAND=( "''${@:2}" )
          if [[ "''${COMMAND[@]}" != "" ]]; then
            COMMAND=( "-c" "''${COMMAND[@]}" )
          fi
          exec /var/run/wrappers/bin/sudo -i -u leo60228 -- /home/leo60228/.c9/result/bin/c9-env "''${COMMAND[@]}"
        ''}/bin/c9shell.sh";
      };
    };
  }
)
