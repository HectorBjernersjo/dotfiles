{ config, pkgs, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;

  # desktop.nix
  hardware.graphics = {
    enable = true;
    enable32Bit = true;         # <- critical for Steam
    # Ensure the Vulkan loader is present for both arches
    extraPackages   = with pkgs;               [ mesa.drivers vulkan-loader ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ mesa.drivers vulkan-loader ];
  };

services.logind.settings = {
  Login = {
    IdleAction = "suspend";
    IdleActionSec = "1min";
    # IdleActionOnlyOnExternalPower = "yes";  # optional
  };
};

  programs.steam.enable = true;

  environment.variables = {
    SDL_VIDEODRIVER = "wayland,x11";  # don’t force Wayland-only
    AMD_VULKAN_ICD  = "RADV";         # stick to Mesa RADV (good for Navi10)
    HYPRLAND_FORCE_NO_FRACTIONAL = "0";
    HYPRLAND_FORCE_FRACTIONAL = "1";
  };

  # Wayland/desktop stack & GUI apps
  programs.hyprland.enable = true;

  # Optional autologin on TTY
  services.getty.autologinUser = "hector";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  boot.kernelParams = [ "mem_sleep_default=deep" ];

  # Wayland helpers and desktop packages
  environment.systemPackages = with pkgs; [
    kitty wofi waybar wl-clipboard
    swww grim slurp swappy
    bibata-cursors wlsunset
    firefox google-chrome
    code-cursor
    discord lutris
    insync
    xremap
    pavucontrol
    spotify
    gimp
    nautilus
    papirus-icon-theme
    xfce.thunar
    kdePackages.dolphin bruno
  ];

  # xremap service for Hyprland
  services.xremap = {
    serviceMode = "system";
    withHypr = true;
    watch = true;
    mouse = true;
    config = {
      modmap = [
        { name = "Global"; remap = { "CapsLock" = "Esc"; }; }
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

  # Fonts (desktop)
  fonts.packages = with pkgs; [
    (nerd-fonts.jetbrains-mono)
  ];
}
