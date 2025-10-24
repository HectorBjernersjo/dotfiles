{ config, pkgs, ... }:

{
  imports = [
    ../development/haskell.nix
    ../development/rust.nix
    ../development/python.nix
    ../development/lua.nix
    ../development/nix.nix
    ../development/typescript.nix
  ];

  # Locale & timezone
  time.timeZone = "Europe/Stockholm";
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

  # Console / keyboard (safe in both)
  console.keyMap = "sv-latin1";
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # User
  users.users.hector = {
    isNormalUser = true;
    description = "Hector Bjernersjö";
    extraGroups = [ "wheel" "input" "uinput" ]; # networkmanager is desktop-only
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Common CLI/dev tooling (no GUI stuff here)
  environment.systemPackages = with pkgs; [
    vim neovim git stow tmux ripgrep fzf zoxide starship gdu wget zip unzip
    gcc nodejs cargo rustc fastfetch trash-cli killall fnm tree pkg-config openssl openssl.dev
    cmake gnumake sqlite sqls
  ];

  # Keep stateVersion consistent across both
  system.stateVersion = "25.05";
}
