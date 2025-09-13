# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "taurus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hector = {
    isNormalUser = true;
    description = "Hector Bjernersjö";
    extraGroups = [ "networkmanager" "wheel" "input" "uinput"];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "hector";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  security.sudo.wheelNeedsPassword = false;

  # services.xserver.enable = true; # if you use Xwayland
  # xdg.portal.enable = true;
  # xdg.portal.extraPortals = [
  #   pkgs.xdg-desktop-portal-gtk
  #   pkgs.xdg-desktop-portal-hyprland
  # ];

  # xremap service configuration for Hyprland
  services.xremap = {
    serviceMode = "system";
    withHypr = true;
    watch = true;
    mouse = true;
    config = {
      modmap = [
        {
          name = "Global";
          remap = { "CapsLock" = "Esc"; };
        }
      ];
      keymap = [
        {
          name = "Alt hjkl to arrows";
          remap = {
            "M-h" = "LEFT";
            "M-j" = "DOWN";
            "M-k" = "UP";
            "M-l" = "RIGHT";
          };
        }
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  vim
  wget
  neovim
  git
  kitty
  wofi
  stow
  tmux
  nodejs
  gcc
  unzip
  firefox
  wl-clipboard
  ripgrep
  fzf
  waybar
  killall
  cargo
  rustc
  fnm
  zoxide
  starship
  trash-cli
  fastfetch
  bibata-cursors
  gdu
  swww
  code-cursor
  grim
  slurp
  swappy

  xremap
  discord
  google-chrome
  steam
  lutris

  (python3.withPackages (pythonPackages: with pythonPackages; [
    numpy 
    psutil
  ]))

  haskellPackages.ghc
  haskellPackages.cabal-install
  haskellPackages.haskell-language-server
  ];


  # Enable fonts
  fonts.packages = with pkgs; [
    (nerd-fonts.jetbrains-mono)
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
  system.stateVersion = "25.05"; # Did you read the comment?

}
