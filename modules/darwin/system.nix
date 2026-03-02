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

  system.primaryUser = "fabiobaser";

  programs.zsh.enable = true;

  # Homebrew — für Casks und was nicht in nixpkgs ist
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate  = true;
      upgrade     = true;
      cleanup     = "zap";  # nicht deklarierte Casks werden entfernt
    };
    taps = [
    "nikitabobko/tap"
    ];
    brews = [
      # brew-only formulas hier
    ];
    casks = [
      "raycast"
      "1password"
      "ghostty"
      "arc"
      "brooklyn"
      "discord"
      "espanso"
      "eurkey"
      "google-chrome"
      "obs"
      "tunnelblick"
      "setapp"
      "displaylink"
      "kap"
      "karabiner-elements"
      "microsoft-teams"
      "nikitabobko/tap/aerospace"
      "elgato-stream-deck"
      "spotify"
    ];
    masApps = {
      # "App Name" = <App Store ID>;
      # "Lungo"    = 1263070803;
    };
  };

  system.defaults = {
    controlcenter = {
      BatteryShowPercentage = true;
    };
    finder = {
      CreateDesktop = false;
    };
    dock = {
      autohide     = true;
      show-recents = false;
      tilesize = 64;
      largesize = 80;
      magnification = true;
      persistent-apps = [
	"/Applications/Arc.app"
	"/Applications/OBS.app"
	"/Applications/Ghostty.app"
      ];
      persistent-others = [
      { 
      	folder = { path = "/Users/fabiobaser/Desktop/"; showas = "grid"; displayas = "folder"; arrangement = "date-modified"; };
      }
      { 
      	folder = { path = "/Users/fabiobaser/Downloads/"; showas = "grid"; displayas = "folder"; arrangement = "date-modified"; };
      }
      ];
    };
  };

  system.stateVersion = 5;
}
