{ config, pkgs, ... }:
{
  config = import ./configuration.nix { pkgs = pkgs; config=config; };
  hostBridge = "br1020";
  localAddress = "10.5.20.7/24";
  localAddress6 = "2001:470:dc6b::7/64";
  autoStart = true;
  privateNetwork = true;
}
