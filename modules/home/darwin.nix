{ pkgs, ... }:

{
  # macOS-only Pakete die in nixpkgs verfügbar sind
  home.packages = with pkgs; [
    mas  # Mac App Store CLI
    yabai
  ];

  home.sessionVariables = {
    BROWSER = "open";
  };

  programs.git.settings.credential.helper = "osxkeychain";

  # Finder, Dock, Keyboard defaults
  targets.darwin.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      KeyRepeat                = 2;
      InitialKeyRepeat         = 15;
      AppleShowAllExtensions   = true;
    };
    "com.apple.dock" = {
      autohide     = true;
      show-recents = false;
      tilesize     = 48;
    };
    "com.apple.finder" = {
      ShowPathbar   = true;
      ShowStatusBar = true;
    };
  };
}
