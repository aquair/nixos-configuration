{ config, lib, pkgs, ... }:
let
  #scd-pkcs11 = pkgs.callPackage ../packages/scd-pkcs11/default.nix {};
  python3-edgetpu = pkgs.callPackage ../packages/python3-edgetpu/default.nix {};
  python3-tflite = pkgs.callPackage ../packages/python3-tflite/default.nix {};

  vscode-extensions = (with pkgs.vscode-extensions; [
      #bbenoist.Nix
      ms-python.python
      #ms-azuretools.vscode-docker
      #ms-vscode-remote.remote-ssh
    ]);
  vscode-with-extensions = pkgs.vscode-with-extensions.override {
      vscodeExtensions = vscode-extensions;
    };

in
{
  imports = [
    ./base.nix
    ./wallpapers.nix
    ./bare_metal.nix
    #./systemd_user/gpg-agent.nix
    #./x11.nix

  ];

  powerManagement = {
    enable = true;
    # cpuFreqGovernor = "ondemand";
  };

  gtk.iconCache.enable = true;

  hardware = {
    enableAllFirmware = true;
    pulseaudio = {
      enable = true;
      support32Bit = true;
      package = pkgs.pulseaudioFull;

      extraModules = [
        pkgs.pulseaudio-modules-bt
      ];

      daemon = {
        config = {
          "flat-volumes" = "no";
          "resample-method" = "speex-float-5";
          "realtime-scheduling" = "yes";
          "high-priority" = "yes";
          "realtime-priority" = 8;
          "default-fragments" = 5;
          "default-fragment-size-msec" = 2;
        };
      };
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluezFull;
    };

    opengl = {
      enable = true;
      driSupport32Bit = true;
      #s3tcSupport = true;
      extraPackages = with pkgs; [ intel-media-driver libvdpau-va-gl vaapiVdpau (vaapiIntel.override {  enableHybridCodec = true;  }) ];
      extraPackages32 = with pkgs; [ 	intel-media-driver libvdpau-va-gl vaapiVdpau (vaapiIntel.override {  enableHybridCodec = true;  }) ];
    };

    steam-hardware = {
      enable = true;
    };

    ledger = {
      enable = true;
    };

  };

  networking.networkmanager.enable = true;



  environment.systemPackages = with pkgs; [
    #Browsers
    unstable.firefox
    unstable.chromium
    unstable.google-chrome
    tor-browser-bundle-bin

    #Media
    spotify
    vlc
    mplayer
    smplayer
    pavucontrol
    pasystray
    audacity
    gimp
    exiftool
    playerctl
    deluge

    #Programming
    unstable.atom

    (python3.withPackages(ps: with ps; [ yapf jedi flake8 autopep8 uvicorn python3-edgetpu tensorflow numpy pillow python3-tflite ]))

    insomnia
    emacs


    #Interface
    alacritty
    rxvt_unicode
    synapse
    feh
    (freerdp.override { pcsclite = pcsclite; libpulseaudio=libpulseaudio; } )
    rdesktop
    appimage-run

    #Ricing
    paper-icon-theme
    hicolor-icon-theme
    gnome2.gnome_icon_theme
    gnome3.adwaita-icon-theme
    pantheon.elementary-icon-theme
    #gtk3
    #gtk-engine-murrine
    lxappearance

    #Graphical System tools
    gnome3.gedit
    gnome3.nautilus
    gnome3.sushi
    gnome3.file-roller
    gparted
    file
    keepass
    shutter

    #Office
    libreoffice
    mupdf
    #adobe-reader

    #Communication
    pidgin
    signal-desktop
    tdesktop
    unstable.teams
    #skype

    (unstable-small.steam.override {  extraPkgs = pkgs: with pkgs.pkgsi686Linux; [ libva ]; })

    #Games
    #unstable-small.steam
    #(unstable.steam.override {  extraPkgs = pkgs: with pkgs.pkgsi686Linux; [ alsaLib alsaPlugins libpulseaudio ]; })
    (unstable.winetricks.override { wine = unstable.wine.override { wineBuild = "wineWow"; };} )
    (unstable.wine.override { wineBuild = "wineWow"; })
    virtualgl
    xboxdrv

    #Graphical network tools
    wireshark

    #Security
    libu2f-host
    yubikey-personalization
    yubico-piv-tool
    pcsctools
    unstable.opensc
    yubikey-manager
    openssl
    unstable.libp11
    #scd-pkcs11
    kdeApplications.kleopatra

    pass
    qtpass
    pwgen

    unetbootin

    teensy-loader-cli
    #unstable.qmk_firmware

    #Accessories
    piper
    android-file-transfer
    go-mtpfs

    sweethome3d.application

    #Terminal system tools
    lm_sensors
    picocom

    gnome3.gvfs
    gtk3
    gsettings-desktop-schemas

    #virtualisation
    virtmanager
    vscode-with-extensions

  ];
	
  environment.extraSetup = ''
      ln -s ${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0 $out/share
    '';

  programs = {
    ssh = {
      startAgent = false;

      extraConfig = ''
        CanonicalizeHostname yes
        CanonicalDomains jonas.systems internal.jonas.systems

        Host *.jonas.systems
          ForwardAgent yes
        '';
    };

    chromium = {
      enable = true;
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
        "ldpochfccmkkmhdbclfhpagapcfdljkj" # Decentraleyes
        "kajibbejlbohfaggdiogboambcijhkke" # Mailvelope
      ];
      defaultSearchProviderSearchURL = "https://duckduckgo.com/?q=%s";
      defaultSearchProviderSuggestURL = "https://duckduckgo.com/?q=%s";
      homepageLocation = "about:blank";
    };

    browserpass = {
      enable = true;
    };

    gnupg = {
      agent = {
        enable = true;
        pinentryFlavor = "gnome3";
        #enableBrowserSocket = true;
        enableExtraSocket = true;
        enableSSHSupport = true;
      };
      package = pkgs.unstable.gnupg;
    };

    adb = {
      enable = true;
    };


  #firejail = {
  #  enable = true;
  #};


  };


  nixpkgs.config = {
    allowBroken = true;
    chromium = {
      #enableAdobeFlash = true;
      #enablePepperPDF = true;
      #enableWideVine = true; #Still broken
      pulseSupport = true;
    };
    firefox = {
      #enableAdobeFlash = true;
      enableWideVine = true;
      #enableVLC = true;
    };

  };


  services = {
      gvfs.enable = true;
      printing  = {
        enable = true;
      };
      avahi = {
        nssmdns = true;
        enable = true;
      };
  };

  systemd = {
    user = {

      services = {

        "urxvtd" = {
            enable = true;
            description = "rxvt unicode daemon";
            wantedBy = [ "default.target" ];
            path = [ pkgs.rxvt_unicode ];
            serviceConfig.Restart = "always";
            serviceConfig.RestartSec = 2;
            serviceConfig.ExecStart = "${pkgs.rxvt_unicode}/bin/urxvtd -q -o";
          };
      };
    };
  };


  /*
    # GTK3 global theme (widget and icon theme)
  environment.etc."gtk-3.0/settings.ini" = {
    text = ''
      gtk-theme-name=Adapta-Nokto
      gtk-icon-theme-name="elementary"
      gtk-font-name=Sans 10
      gtk-cursor-theme-size=0
      gtk-toolbar-style=GTK_TOOLBAR_BOTH
      gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
      gtk-button-images=1
      gtk-menu-images=1
      gtk-enable-event-sounds=1
      gtk-enable-input-feedback-sounds=1
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle=hintfull
      gtk-xft-rgba=rgb
      '';
    mode = "444";
  };

  environment.etc."gtk-2.0/gtkrc" = {
    text = ''
      gtk-theme-name="Adapta-Nokto"
      gtk-icon-theme-name="elementary"
      gtk-font-name="Sans 10"
      gtk-cursor-theme-size=0
      gtk-toolbar-style=GTK_TOOLBAR_BOTH
      gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
      gtk-button-images=1
      gtk-menu-images=1
      gtk-enable-event-sounds=1
      gtk-enable-input-feedback-sounds=1
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintfull"
      gtk-xft-rgba="rgb"
      '';
    mode = "444";
  };

  environment.variables = {
    #GTK_DATA_PREFIX = "/run/current-system/sw";

  };
  */

  virtualisation = {
    docker = {
      enable = true;
    #extraOptions = ''
    #    --storage-opt dm.basesize=20G
    #  '';
    };
  };
  fonts = {
     enableFontDir = true;
     enableGhostscriptFonts = true;
     fonts = with pkgs; [
       google-fonts
       hack-font
       font-awesome-ttf
       powerline-fonts
       dejavu_fonts
       liberation_ttf
       emacs-all-the-icons-fonts
     ];
   };
   services = {

     upower.enable = true;

     tor = {
       enable = true;
       client.enable = true;
     };

     gpm.enable = true;

     openssh.forwardX11 = true;

     #udisks2.enable = true;
     devmon.enable = true;

     gnome3 = {
       gvfs.enable = true;
    #   gnome-disks.enable = true;
    #   gnome-keyring.enable = true;
    #   seahorse.enable = true;
     };

     pcscd = {
       enable = true;
       #plugins = [ pkgs.unstable.ccid ];
     };

     ratbagd = {
       enable = true;
     };

     udev = {
       packages = [
          pkgs.libu2f-host
          pkgs.yubikey-personalization
          pkgs.yubico-piv-tool
          pkgs.yubikey-manager
          pkgs.pcsctools
          pkgs.unstable.opensc
       ];


       extraRules = ''
          # this udev file should be used with udev 188 and newer
          ACTION!="add|change", GOTO="u2f_end"

          # Yubico YubiKey
          KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1050", ATTRS{idProduct}=="0113|0114|0115|0116|0120|0402|0403|0406|0407|0410", MODE="0660", GROUP="plugdev", TAG+="uaccess"

          LABEL="u2f_end"
        '';

    };

    redshift = {
      enable = true;
    };

  };

  #sound.mediaKeys.enable = true;

  nixpkgs.overlays = [
      (self: super: {
        #steam = pkgs.steam
        #pcsclite = pkgs.unstable.pcsclite;
      }
      )
    ];

    nixpkgs.config.permittedInsecurePackages = [
             "p7zip-16.02"
           ];

}
