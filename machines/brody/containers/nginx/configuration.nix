{ config, pkgs, ... }:
let
in
{
  imports = [
    ../../../../config/minimum.nix
    ../../../../config/services/nginx/nginx.nix
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
/*
services = {
    nginx = {
      enable = true;

    };
  };
*/
}