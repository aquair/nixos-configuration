{ config, pkgs, ... }:
let
  dnsServerAddress = "10.5.6.4";
in
{
  imports = [
    ../../../../config/minimum.nix
];

networking = {
  firewall = {
    allowedUDPPorts = [ 4789 ];
  };

  defaultGateway = {
    address = "10.5.6.1";
    interface = "eth0";
  };
};

systemd.network = {
  netdevs.vx02.vxlanConfig = {
    Id = 1;
    Remote = "10.5.6.8";
    Local = "172.16.1.2";
  };

  networks = [ "vx02" ];

};

environment.systemPackages = with pkgs; [
];

services = {
  };
}
