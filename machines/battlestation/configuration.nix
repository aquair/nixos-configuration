{ config, lib, pkgs, ... }:
let
  unstable = import <nixos-unstable> {};
in
{
  imports = [
    ../../config/x_desktop.nix
  ];
  networking.hostName = "battlestation";

  boot.loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };


  services.xserver.videoDrivers = [ "amdgpu-pro" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
 users.extraUsers.user = {
    isNormalUser = true;
    uid = 1003;
    home = "/home/user/";
    extraGroups = [ "wheel" "networkmanager" ];
    useDefaultShell = true;
 };

 environment.systemPackages = with pkgs; [
  i3pystatus
  python3
  teamspeak_client
  #sway
  #way-cooler
  #wayland
  #weston
  unstable.alacritty
 ];



}
