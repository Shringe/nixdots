{
  config,
  lib,
  inputs,
  ...
}:
let
  namespace = "searxng";
  isolated = {
    enable = true;
    vpnNamespace = namespace;
  };
in
{
  imports = [
    inputs.vpn-confinement.nixosModules.default
  ];

  config = lib.mkIf config.nixosModules.server.services.searxng.useVpn {
    sops.secrets."server/services/searxng/vpn" = { };
    nixosModules.server.services.searxng.host = "192.168.15.1";

    vpnNamespaces.${namespace} = {
      enable = true;
      wireguardConfigFile = config.sops.secrets."server/services/searxng/vpn".path;
      accessibleFrom = [
        "192.168.0.0/24"
      ];

      portMappings = with config.nixosModules.server.services.searxng; [
        {
          from = port;
          to = port;
          protocol = "tcp";
        }
      ];
    };

    systemd.services = {
      redis-searx.vpnConfinement = isolated;
      searx.vpnConfinement = isolated;
      searx-init.vpnConfinement = isolated;
    };
  };
}
