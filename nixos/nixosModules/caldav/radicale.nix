{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.caldav.radicale;
in {
  options.nixosModules.caldav.radicale = {
    enable = mkEnableOption "Radicale hosting";

    ip = mkOption {
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 47220;
    };

    description = mkOption {
      type = types.str;
      default = "Caldav and Carddav server";
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.ip}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://radicale.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.str;
      default = "radicale.svg";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."radicale/users" = {
      owner = config.users.users.radicale.name;
    };

    environment.systemPackages = with pkgs; [
      apacheHttpd
    ];

    services.radicale = {
      enable = true;
      settings = {
        server = {
          hosts = [ "${cfg.ip}:${toString cfg.port}" ];
        };

        auth = {
          type = "htpasswd";
          # sudo -u radicale htpasswd -bB /var/lib/radicale/users <username> <newpassword>
          htpasswd_filename = config.sops.secrets."radicale/users".path;
          htpasswd_encryption = "bcrypt";
        };

        storage.filesystem_folder = "/var/lib/radicale/collections";

        web = {                                                                                            
          type = "radicale_infcloud";
          # The weird spacing here is on purpose to hack the INI formatter...
          infcloud_config = ''
            globalInterfaceLanguage = "en_US";
                            globalTimeZone = "America/Chicago";
          '';                                         
        };          
      };
    };

    systemd.services.radicale.environment.PYTHONPATH = 
      let    
        python = pkgs.python3.withPackages (ps: with ps; [
          radicale_infcloud
          pytz                                                                                             
          setuptools  
        ]);
      in
      "${python}/${pkgs.python3.sitePackages}";
  };
}
