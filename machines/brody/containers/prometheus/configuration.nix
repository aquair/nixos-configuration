{ config, pkgs, ... }:
let
interface_lookups = [
  {
    labelname = "ifDescr";
    labels = [ "ifIndex" ];
    oid = "1.3.6.1.2.1.2.2.1.2";
    type = "DisplayString";
  }
  {
    labelname = "ifName";
    labels = [ "ifIndex" ];
    oid = "1.3.6.1.2.1.31.1.1.1.1";
    type = "DisplayString";
  }
  {
    labelname = "ifAlias";
    labels = [ "ifIndex" ];
    oid = "1.3.6.1.2.1.31.1.1.1.18";
    type = "DisplayString";
  }
];
system_lookups = [
  {
    labelname = "sysDescr";
    labels = [  ];
    oid = "1.3.6.1.2.1.1.1.0";
    type = "DisplayString";
  }
  {
    labelname = "sysName";
    labels = [ ];
    oid = "1.3.6.1.2.1.1.5.0";
    type = "DisplayString";
  }
  {
    labelname = "sysLocation";
    labels = [ ];
    oid = "1.3.6.1.2.1.1.6.0";
    type = "DisplayString";
  }
  {
    labelname = "sysContact";
    labels = [ ];
    oid = "1.3.6.1.2.1.1.4.0";
    type = "DisplayString";
  }
];

in
{
  imports = [
    ../../../../config/minimum.nix
];

networking = {
  firewall = {
    enable = false;
  };
  nameservers = [ "10.5.20.1" ];

  defaultGateway = {
    address = "10.5.20.1";
    interface = "eth0";
  };
};

environment.systemPackages = with pkgs; [

];

services = {
  prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "node";
        scrape_interval = "10s";
        static_configs = [
          {
            targets = [
              "10.5.20.4:9100"
            ];
            labels = {
              alias = "${config.networking.hostName}";
            };
          }
        ];
      }
      {
        job_name = "hass";
        scrape_interval = "60s";
        static_configs = [
          {
            targets = [
              "10.5.20.6:8123"
            ];
            labels = {
              alias = "${config.networking.hostName}";
            };
          }
        ];
        metrics_path = "/api/prometheus";
        scheme = "http";
        params = {
          api_password = ["8wzUfUfLa6ZuewFd4j2UxtVu"];
        };
      }
      {
        job_name = "snmp";
        static_configs = [
          {
            targets = [
              "10.5.20.1"
            ];
          }
        ];
        metrics_path = "/snmp";
        params = {
          module = [ "if_mib" ];
        };
        relabel_configs = [
          {
            source_labels = [ "__address__" ];
            target_label = "__param_target";
          }
          {
            source_labels = [ "__param_target" ];
            target_label = "instance";
          }
          {
            source_labels = [];
            target_label = "__address__";
            replacement = "127.0.0.1:9116";
          }
        ];
      }
  ];

    exporters = {
      snmp = {
        enable = true;

        configuration = {
          "default" = {
            "version" = 2;
            "auth" = {
              "community" = "public";
            };
          };
          "if_mib" = {
            "version" = 2;
            "auth" = {
              "community" = "public";
            };
            walk = [
              "1.3.6.1.2.1.2.2"
              "1.3.6.1.2.1.31.1.1"
            ];
            metrics = [
              {
                name = "ifIndex";
                oid = "1.3.6.1.2.1.2.2.1.1";
                type = "gauge";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifType";
                oid = "1.3.6.1.2.1.2.2.1.3";
                type = "gauge";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifHCOutOctets";
                oid = "1.3.6.1.2.1.31.1.1.1.10";
                type = "counter";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifHCOutUcastPkts";
                oid = "1.3.6.1.2.1.31.1.1.1.11";
                type = "counter";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifHCOutMulticastPkts";
                oid = "1.3.6.1.2.1.31.1.1.1.12";
                type = "counter";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifHCOutBroadcastPkts";
                oid = "1.3.6.1.2.1.31.1.1.1.13";
                type = "counter";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifHighSpeed";
                oid = "1.3.6.1.2.1.31.1.1.1.15";
                type = "gauge";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifHCInOctets";
                oid = "1.3.6.1.2.1.31.1.1.1.6";
                type = "counter";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifHCInUcastPkts";
                oid = "1.3.6.1.2.1.31.1.1.1.7";
                type = "counter";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifHCInMulticastPkts";
                oid = "1.3.6.1.2.1.31.1.1.1.8";
                type = "counter";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifHCInBroadcastPkts";
                oid = "1.3.6.1.2.1.31.1.1.1.9";
                type = "counter";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifMtu";
                oid = "1.3.6.1.2.1.2.2.1.4";
                type = "gauge";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifInDiscards";
                oid = "1.3.6.1.2.1.2.2.1.13";
                type = "counter";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifInErrors";
                oid = "1.3.6.1.2.1.2.2.1.14";
                type = "counter";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "ifInUnknownProtos";
                oid = "1.3.6.1.2.1.2.2.1.15";
                type = "counter";
                indexes = [
                  {
                    labelname = "ifIndex";
                    type = "Integer";
                  }
                ];
                lookups = interface_lookups;
              }
              {
                name = "sysUpTime";
                oid = "1.3.6.1.2.1.1.3";
                type = "counter";
                lookups = system_lookups;
              }

            ];
          };
        };
      };
    };
  };
};

}
