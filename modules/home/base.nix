{ config, pkgs, lib, flakeRoot, ... }:

{
  home.username = "fabiobaser";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin
    then "/Users/fabiobaser"
    else "/home/fabiobaser";
  home.stateVersion = "25.11";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  home.packages = with pkgs; [
    jdk17
    (androidenv.composeAndroidPackages {
      cmdLineToolsVersion = "11.0";
      platformVersions = [ "34" ];
      buildToolsVersions = [ "34.0.0" ];
      includeEmulator = true;
      includeSystemImages = true;
    }).androidsdk
    neovim
    gh
    bat
    eza
    ripgrep
    lazygit
    starship
    # JavaScript
    bun
    pnpm
    fnm
    fzf
    # Libs
    gnumake
    gcc
    cargo
    # AI
    opencode
    unzip
    btop
    claude-code
  ];

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/dotfiles/nvim";
  };

  home.file.".config/tmuxinator" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/dotfiles/tmuxinator";
  };

  home.file.".config/nunchux" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/dotfiles/nunchux";
  };


  home.sessionVariables = {
    EDITOR = "nvim";
    PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
    JAVA_HOME = "${pkgs.jdk17}/lib/openjdk";
    ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
    ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Android/Sdk";
  };

  home.sessionPath = [
    "$PNPM_HOME"
    "${config.home.homeDirectory}/platform-tools"
  ];

  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      size = 99999;
      saveNoDups = true;
      append = true;
    };
    shellAliases = {
      c = "clear";
      v = "nvim";
      # home-manager
      hm = "home-manager";
      hms = "home-manager switch";
      hmc = "nvim ~/.config/home-manager/home.nix";
      # zsh
      zshrc = "nvim ~/.zshrc";
      zshreload = "source ~/.zshrc";
      # eza
      l = "eza -T -L 1 --icons --group-directories-first -I .git";
      la = "eza -T -L 1 --icons -a --group-directories-first -I .git";
      ll = "eza -T -L 2 --icons --group-directories-first -I .git";
      lla = "eza -T -L 2 --icons -a --group-directories-first -I .git";
      lll = "eza -T -L 3 --icons --group-directories-first -I .git";
      lg = "lazygit";
      updateNix = "nix flake update --extra-experimental-features 'nix-command flakes' --flake ~/.config/home-manager";
      reloadLinux = "home-manager switch --extra-experimental-features \"nix-command flakes\" --flake ~/.config/home-manager#linux";
      reloadMac = "sudo darwin-rebuild switch --flake ~/.config/home-manager#mac";
      # Tmux
      twhm = "tmux new-window -n \"Home Manager\" -c ${config.home.homeDirectory}/.config/home-manager \"nvim\"";
    };
    initContent =
      let
        earlyInit = lib.mkOrder 500 "";
        mainInit = lib.mkOrder 1000 ''
          	eval "$(fnm env --shell zsh)"
          	'';
      in
      lib.mkMerge [ earlyInit mainInit ];
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    baseIndex = 1;
    escapeTime = 10;
    keyMode = "vi";
    tmuxinator.enable = true;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.dotbar;
        extraConfig = ''
          set -g @tmux-dotbar-bg "#1e1e2e"
          set -g @tmux-dotbar-fg "#585b70"
          set -g @tmux-dotbar-fg-current "#cdd6f4"
          set -g @tmux-dotbar-fg-session "#9399b2"
          set -g @tmux-dotbar-fg-prefix "#cba6f7"
          set -g @tmux-dotbar-right true
          set -g @tmux-dotbar-status-right "%A %H:%M"
        '';
      }
      {
        plugin = tmuxPlugins.vim-tmux-navigator;
        extraConfig = ''
          is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
              | grep -iqE '^[^TXZ ]+ +(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?$'"
          bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
          bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
          bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
          bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
          tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
          if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
              "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
          if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
              "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"
          bind-key -T copy-mode-vi 'C-h' select-pane -L
          bind-key -T copy-mode-vi 'C-j' select-pane -D
          bind-key -T copy-mode-vi 'C-k' select-pane -U
          bind-key -T copy-mode-vi 'C-l' select-pane -R
        '';
      }
    ];
    extraConfig = ''
      set -g @plugin 'datamadsen/nunchux'
      set -g @plugin 'lost-melody/tmux-command-palette'
      set -g @plugin 'Ataraxy-Labs/opensessions'
      set -g @plugin 'vndmp4/tmux-fzf-session-switch'

      bind-key r source-file ~/.config/tmux/.tmux.conf \; display "Reloaded Tmux Config"
      bind-key -T copy-mode-vi v   send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-selection
      bind-key -T copy-mode-vi y   send-keys -X copy-selection-and-cancel

      set-option -sa terminal-features ',alacritty:RGB'
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      set-option -g  default-terminal "tmux-256color"
      set-option -ga terminal-features ",alacritty:usstyle"
      set-option -g status-interval 5
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'

      run '~/.tmux/plugins/tpm/tpm'
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = { };
  };

  programs.zoxide.enable = true;
  programs.lazygit.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Fabio Baser";
        email = "git@fabiobaser.de";
      };
      init.defaultBranch = "main";
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
    };
  };

  programs.home-manager.enable = true;
}
