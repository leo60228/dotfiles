let lib = import ../lib; in
lib.makeComponent "mailserver"
({cfg, pkgs, lib, ...}: with lib; {
	opts = {};

	config = {
		mailserver = {
			enable = true;
			fqdn = "***REMOVED***";
			domains = [ "***REMOVED***" "***REMOVED***" ];

			loginAccounts = {
				"***REMOVED***@***REMOVED***" = {
					hashedPassword = builtins.readFile /home/leo60228/.creds/email;

					aliases = [
						#"leo@leo60228.space"
					];

					catchAll = [
						"***REMOVED***"
						"***REMOVED***"
						#"leo60228.space"
					];
				};
			};

			certificateScheme = 1;
			certificateFile = "/var/lib/acme/***REMOVED***/fullchain.pem";
			keyFile = "/var/lib/acme/***REMOVED***/key.pem";

			enableImap = true;
			enablePop3 = true;
			enableImapSsl = true;
			enablePop3Ssl = true;

			enableManageSieve = true;

			virusScanning = true;
		};
	};
})

