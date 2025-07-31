# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  devenv-1-3-1 = import <devenv-1-3-1> { config = { allowUnfree = true; }; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  boot.initrd.luks.devices."luks-a68b36d6-cc1e-4c13-802a-6ce4d78ee864".device = "/dev/disk/by-uuid/a68b36d6-cc1e-4c13-802a-6ce4d78ee864";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "euro";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  services.teamviewer.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marcosh = {
    isNormalUser = true;
    description = "marcosh";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ferdium
    signal-desktop
    obs-studio
    keepassxc
    devenv-1-3-1.devenv
    direnv
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions; [
        bbenoist.nix
        justusadam.language-haskell
        haskell.haskell
        mkhl.direnv
        eamodio.gitlens
        shardulm94.trailing-spaces
        davidlday.languagetool-linter
        ms-vsliveshare.vsliveshare
        # unstable.vscode-extensions.ethersync.ethersync
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "run-on-save";
          publisher = "pucelle";
          version = "1.9.0";
          sha256 = "5EsWgfbHLUILfPfn/nJygfi3z76DGTG+xyytV7Gz5eg=";
        }
        {
          name = "open-in-browser";
          publisher = "techer";
          version = "2.0.0";
          sha256 = "3XYRMuWEJfhureHmx1KfT+N9aBuqDagj0FErJQF/teg=";
        }
        {
          name = "language-purescript";
          publisher = "nwolverson";
          version = "0.2.8";
          sha256 = "2uOwCHvnlQQM8s8n7dtvIaMgpW8ROeoUraM02rncH9o=";
        }
        {
          name = "ide-purescript";
          publisher = "nwolverson";
          version = "0.26.6";
          sha256 = "zYLAcPgvfouMQj3NJlNJA0DNeayKxQhOYNloRN2YuU8=";
        }
        {
          name = "bruno";
          publisher = "bruno-api-client";
          version = "3.1.0";
          sha256 = "jLQincxitnVCCeeaoX0SOuj5PJyR7CdOjK4Kl52ShlA=";
        }
      ];
    })
    gitFull
    qbittorrent
    vim
    vlc
    bruno
    docker
    nodejs_20
    postgresql
    graphite-cli
    gnumake
    libreoffice
    php83
    php83Packages.composer
    zoom-us
    shotcut
    htop
    ungoogled-chromium
    arduino-ide
    gnome-calculator
    yarn
    librewolf
    languagetool
    zulu #java
    kdePackages.audiocd-kio
    kdePackages.kmines
    kdePackages.markdownpart
    rar
    rustdesk
    pandoc
    teamviewer
    # unstable.ethersync
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  virtualisation.docker.enable = true;

  # Install tmux
  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = '' # used for less common options, intelligently combines if defined in multiple places.
      set-option -g history-limit 50000

      # sane scrolling
      set-option -g mouse on
      set -ga terminal-overrides ',xterm*:smcup@:rmcup@'

      # new pane on same folder
      bind '"' split-window    -c "#{pane_current_path}"
      bind %   split-window -h -c "#{pane_current_path}"

      # use zsh instead of bash
      # set -g default-command /usr/bin/zsh

      # use wayland clipboard
      # set -s copy-command 'wl-copy'

      # how to login in ssh agent at start?
    '';
  };

  # Install tmate
  #programs.tmate = {
  #  enable = true;
  #};

  # Install zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      update = "sudo nixos-rebuild switch";
    };
    histSize = 50000;
  };

  programs.direnv.enable = true;

  nix.extraOptions = ''
    trusted-users = root marcosh
  '';
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  # needed to run npm install on bm-frontend
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    gmp
  ];

  programs.git = {
    enable = true;
    config = {
      user.email = "pasafama@gmail.com";
      user.name = "Marco Perone";
      init.defaultBranch = "main";
      gui.gcwarning = false;
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    initialDatabases = [
      { name = "hanoi-game"; }
    ];
    ensureUsers = [
      {
        name = "marcosh";
        ensurePermissions = { "*.*" = "All PRIVILEGES"; };
      }
    ];
  };
}
