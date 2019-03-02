{ config, lib, pkgs, ... }:
{
  imports = [
    ../../config/desktop_base.nix
    ../../config/kde_x11.nix
  ];

  system.stateVersion = "18.09";



  networking = {
    hostName = "alicia";
    enableIPv6 = false;
    firewall.allowedTCPPorts = [ 3389 ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services = {
    xserver = {
      videoDrivers = [ "radeon" ];

      deviceSection = ''
      Option "DRI3" "1"
      Option "TearFree" "on"
      '';

      displayManager.sddm.autoLogin = {
        user = "alicia";
        enable = true;

      };
    };
    xrdp = {
      enable = true;
      #defaultWindowManager = "startkde";
    };

    lldpd = {
      enable = true;
    };
  };

  programs = {
    sway = {
      enable = true;
    };


  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
 users.extraUsers.alicia = {
    isNormalUser = true;
    uid = 1005;
    home = "/home/alicia/";
    extraGroups = [ "wheel" "networkmanager" ];
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8KXv9W2nvQNpiECqIImuvP2gxbrbMkKRUg53pBFCS/uHuWA8NodOmZo+DHPdzdHCoq7q6fnptdL9xhMgcPuOAnDmL0/oYzZmRa1c0kzag09FL3c4sWVrcNWiNYd7BAMi+Gq7OnQv6QNJ+8NDHyf6HTGKg2GnFTNIi/7rsxaiQwJrLBnMpOs61Vo1rxH9I2HQUY3Dfm3qOu0pAXogc5etxcXWm/8rW/URb6svpKEtwr8zvSgT2WxI0+7sWepRN8WXsvtLXp1vbbVU7r3pBjyFaDpxHrCUCX8HSaZ/l1JL+AuBR6wzqw0Zc6zavYTKmORhxYjn3v1ZlFmUeYXA3OMlN7UopiSGm/BgYekF7PnSFwXcKK5EsPszftHSVzGdW6ULvAbP/g2ItShEeRehEK3yJ/m1cPHQKstrz6P3+NmswYJmNxoSvnKQDaLp8qgMiLqXA47uNE7hh2aOrQpphOsKPbfMGg/ec0+uJoTrC2dHlb5fB9tzgRnUTWs0uXmGb/uYrgeNbIlStEaL5iPzTyfCJYS7eoo69k1vykYyMpfiyjR4dECZ/6GpbNhifr4AW0nhlXR6dva6MwdmgD9C0nHrHJTz6WMfebqe+b9I/G7iUrQeWKy6SEC9UcMFFMD0+2soW08268DAEU7PR+U+Kjoc94OfZtsfmXDNO5kDnuTEh7Q== cardno:000605761294"

    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQiZaFSIJLhOrKnPXH/w6nZobfFT7CTgrHTKzgXvnIUa5wSg0xMI9TrDIJEFp4bR2BaMf1d/IMzR2mKhdQDTxoOZ9kl/mg1ceERCGMNO6J68PB9CGRPDGbLE+kMRKz/29A7nb18KpxGvb28ppt12ajELb1UNU4CTKRruMSARKRStUkDseKETbEWYebgBt2P9sLB4qUGl+3lsCumAvdQoUtoR3UP0ekBqRu+o351eNbzH/Yp1MGmRXCLXXNWHovP9kYBPxdAOEhoMegKqM9V9HiK7mud4wcji67LUpkVRFyP72CrwHNz6vhLOPfIzWR168mjHmnxyDSMyJlzyXm6uCEPcVrX7qJUWZQSywmYAQ5uLV8RDfrqcjzbc+plwJvzsB3WVmu9AFL4rixS8E5Cx+NroX6IUIDFxTZVah5b2cWe55E7W2Z5Ly4/gx2mmgEKC+ay7MhxqIErXsooeDOeXv/l7KrTi/zvHl0zmPLXqwxNfOcDeOpPiU6xtarvojzkrnWk0zOt+m9GOZ4pjwr4IFNmKFKossxKxX88+Q2aJW19nagpwtxnB0xRJyvb9VZf0OuzeTwcPfNNUlIvZBC9+jkVRRK/SX/fs28u6dINVHkqAPUHfXtw13iPdq6sVAMrpdDcNzRYiuH0oArbvGdNfF4IMjOj4Y8EX9GLzyKjUW5gw== cardno:00050000657A"

    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9W1u2xJj0XTyWckww3uPctzpEPo3OZvf+rg7tnk1aSJ4HGX7nJLYdeUfgLe7M0PhvWPJpFP9Jw6EYFmWavqdMQ4k7V2fG44FvRrOczwrpJxSE0YiHtFYa1RCNv6R4cuv5c0agXA8cPNVKAFoRxodhJb/+XWhaNAG0nbA5yoXMymcgQDCZKuoA52b47ay4Ff1QA/jkoM6PGIrBZdNypOTCoLsYealiAokDTTsMPJYQQ76LRKkpM9ysJTkaKsh6OtiOfH0cW5KHTkA5qwh/wDb/0VPZBAy7+J9YiU4zO021A0+JsFe4Gnzr3vGITO/R+RiQoQuzp5UsdeRQylQN97Pe3W6Um57r7is9D8km5ndb/J/mGuZZn7PFQfoFNosYhz0P+xPSjjz9BUQW3vIRGy22BhU+V5KbHxL0SUglHD8zYtkyhUvO//MKvsawqk7oX+I7XtDYu5rDiMDq/5WDU8VhURWx5wMy6wqJlqrDnl6Kp2sXlo6xCm2sZlIyHTKfNy+ctQnrbxl7NnBZuRutWsJVsjZnOl9M+lx/z7Cm5gieCvVAnCgtokRnW+PfVGlQbkerH4qVaH9hS+RyU7lZa4DZPrqe7kMXMUutUsArJWI4ldpSp0ZLwviOSS9DlYmfD6v4Wf1YIL+QHhpvnidkHWxdlhXdghQ0lbdSxWGEkmb22w== cardno:00050000603D"
    ];

 };

 environment.systemPackages = with pkgs; [
  unstable.tuxtyping
  gcompris
 ];

 nixpkgs.overlays = [
     (self: super: {
       #mesa = pkgs.unstable.mesa;
       #mesa_glu = pkgs.unstable.mesa_glu;
       #mesa_noglu = pkgs.unstable.mesa_noglu;
       #mesa_drivers = pkgs.unstable.mesa_drivers;
       #xorg.xf86videoamdgpu = pkgs.unstable.xorg.xf86videoamdgpu;
       #steam-run = pkgs.unstable.steam-run;
       #steam = pkgs.unstable.steam;
       #steam-runtime = pkgs.unstable.steam-runtime;
       #steam-runtime-wrapped = pkgs.unstable.steam-runtime-wrapped;
       #steam-fonts = pkgs.unstable.steam-fonts;
       #steam-chrootenv = pkgs.unstable.steam-chrootenv;
       #vulkan-loader = pkgs.unstable.vulkan-loader;
       #zsh-powerlevel9k = pkgs.unstable.zsh-powerlevel9k;
       #handbrake = super.handbrake.override { useGtk = true;};
     }
     )
   ];





}
