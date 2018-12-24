{ config, lib, pkgs, ... }:

{
  imports = [
    ../../config/laptop_base.nix
    ../../config/i3_x11.nix
  ];

  networking.hostName = "lazarus";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

 users.extraUsers = {
    wanida = {
      isNormalUser = true;
      uid = 1001;
      home = "/home/wanida/";
      extraGroups = [ "networkmanager" ];
      createHome = true;
      useDefaultShell = true;
    };
  };

 services = {
   xserver = {

     desktopManager.gnome3.enable = true;
     dpi = 144;

   };
 };

 programs.adb.enable = true;

 environment.systemPackages = with pkgs; [

    # On screen keyboard
    gnome3.caribou
    atk

    heimdall
    heimdall-gui
 ];

}
