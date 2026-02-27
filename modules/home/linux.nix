{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wslu   # wslview, wslpath
    xclip
  ];

  home.sessionVariables = {
    BROWSER = "wslview";
  };

  # programs.git.settings.credential.helper =
  #   "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
}
