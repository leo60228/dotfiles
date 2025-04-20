{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.mediawiki = {
    enable = true;
    package = pkgs.nur.repos.ihaveamac.mediawiki_1_43;
    name = "CHORDIOID Wiki";
    url = "https://chordiwiki.l3.pm";
    passwordFile = "/var/lib/mediawiki/mw-password";
    passwordSender = "chordiwiki@60228.dev";
    webserver = "nginx";
    nginx.hostName = "chordiwiki.l3.pm";

    skins.MinervaNeue = "${config.services.mediawiki.package}/share/mediawiki/skins/MinervaNeue";

    extensions = {
      inherit (pkgs.leoPkgs.mediawiki-extensions)
        CodeMirror
        MobileFrontend
        OpenGraphMeta
        TimedMediaHandler
        Description2
        PortableInfobox
        ;

      WikiEditor = null;
      VisualEditor = null;
      Cite = null;
      AbuseFilter = null;
      PageImages = null;
      ConfirmEdit = null;
      Interwiki = null;
      TemplateData = null;
      CodeEditor = null;
    };

    extraConfig = ''
      wfLoadExtension("ConfirmEdit/QuestyCaptcha");
      $wgCaptchaQuestions = [
        "Who is the main protagonist of CHORDIOID?" => ["Sam", "Sam Mardot"],
        "What genre is CHORDIOID?" => ["Rhythm", "RPG", "Rhythm RPG"],
        "Where does CHORDIOID take place?" => ["Concordia", "Capital", "the Capital"]
      ];

      $wgLogos = [
        '1x' => "https://chordiwiki.l3.pm/chordiwiki-1x.png",
        '1.5x' => "https://chordiwiki.l3.pm/chordiwiki-1.5x.png",
        '2x' => "https://chordiwiki.l3.pm/chordiwiki-2x.png",
        'icon' => "https://chordiwiki.l3.pm/chordiwiki-icon.png"
      ];

      $wgRightsText = "Creative Commons Attribution-ShareAlike";
      $wgRightsUrl = "https://creativecommons.org/licenses/by-sa/4.0/";
      $wgRightsIcon = "$wgResourceBasePath/resources/assets/licenses/cc-by-sa.png";

      $wgUsePathInfo = true;

      $wgSMTP = [
        "host" => "smtp-relay.gmail.com",
        "IDHost" => "60228.dev",
        "localhost" => "60228.dev",
        "port" => 587,
        "auth" => false
      ];

      $wgMainCacheType = CACHE_ACCEL;
      $wgSessionCacheType = CACHE_DB;

      $wgFFmpegLocation = "${pkgs.ffmpeg-headless}/bin/ffmepg";

      $wgEnableMetaDescriptionFunctions = true;

      $wgDefaultMobileSkin = "minerva";

      $wgMinervaNightMode['base'] = true;
      $wgVectorNightMode['logged_in'] = true;
      $wgVectorNightMode['logged_out'] = true;
      $wgDefaultUserOptions['vector-theme'] = 'os';
      $wgDefaultUserOptions['minerva-theme'] = 'os';

      $wgUseCdn = true;

      $wgCodeMirrorV6 = true;
      $wgDefaultUserOptions['usecodemirror'] = 1;
      $wgVisualEditorEnableWikitext = true;

      $wgGroupPermissions['sysop']['interwiki'] = true;
    '';
  };
  services.phpfpm.pools.mediawiki.phpPackage = lib.mkForce (
    pkgs.php82.buildEnv {
      extensions =
        { enabled, all }:
        enabled
        ++ [
          all.opcache
          all.apcu
          all.igbinary
        ];
    }
  );

  users.users.nginx.extraGroups = [ "mediawiki" ];
  services.nginx.virtualHosts."chordiwiki.l3.pm" = {
    forceSSL = true;
    enableACME = true;
    locations."=/chordiwiki-icon.png".alias = ../../files/chordiwiki-icon.png;
    locations."=/chordiwiki-1x.png".alias = ../../files/chordiwiki-1x.png;
    locations."=/chordiwiki-1.5x.png".alias = ../../files/chordiwiki-1.5x.png;
    locations."=/chordiwiki-2x.png".alias = ../../files/chordiwiki-2x.png;
  };
}
