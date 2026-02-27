{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users          = [ "root" "fabiobaser" ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform        = "aarch64-darwin";

  users.users.fabiobaser = {
    home  = "/Users/fabiobaser";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;

  # Homebrew — für Casks und was nicht in nixpkgs ist
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate  = false;
      upgrade     = false;
      # cleanup     = "zap";  # nicht deklarierte Casks werden entfernt
    };
    taps = [
    ];
    brews = [
      # brew-only formulas hier
    ];
    casks = [
      "raycast"
      "1password"
      "ghostty"
    ];
    masApps = {
      # "App Name" = <App Store ID>;
      # "Lungo"    = 1263070803;
    };
  };

  system.defaults = {
    dock = {
      autohide     = true;
      show-recents = false;
    };
  };

  system.stateVersion = 5;
}
