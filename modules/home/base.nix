{ config, pkgs, lib, ... }:

{
  home.username = "fabiobaser";
  home.homeDirectory = if pkgs.stdenv.isDarwin
    then "/Users/fabiobaser"
    else "/home/fabiobaser";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    neovim
    gh
    bat
    eza
    ripgrep
    lazygit
    # JavaScript
    bun
    pnpm
    fnm
    # Libs
    gnumake
    gcc
    cargo
  ];

  home.file = {
    # ".config/nvim" = {
    #   source    = ~/dotfiles/nvim;
    #   recursive = true;
    # };
    # ".config/tmuxinator" = {
    #   source    = ~/dotfiles/tmuxinator;
    #   recursive = true;
    # };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.zsh = {
    enable                    = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable     = true;
    enableCompletion          = true;
    history = {
      size       = 99999;
      saveNoDups = true;
      append     = true;
    };
    shellAliases = {
      c         = "clear";
      v         = "nvim";
      # home-manager
      hm        = "home-manager";
      hms       = "home-manager switch";
      hmc       = "nvim ~/.config/home-manager/home.nix";
      # zsh
      zshrc     = "nvim ~/.zshrc";
      zshreload = "source ~/.zshrc";
      # eza
      l         = "eza -T -L 1 --icons --group-directories-first -I .git";
      la        = "eza -T -L 1 --icons -a --group-directories-first -I .git";
      ll        = "eza -T -L 2 --icons --group-directories-first -I .git";
      lla       = "eza -T -L 2 --icons -a --group-directories-first -I .git";
      lll       = "eza -T -L 3 --icons --group-directories-first -I .git";
      lg        = "lazygit";
    };
    initContent =
      let
        earlyInit = lib.mkOrder 500 "";
        mainInit  = lib.mkOrder 1000 ''eval "$(fnm env --shell zsh)"'';
      in
      lib.mkMerge [ earlyInit mainInit ];
  };

  programs.tmux = {
    enable      = true;
    mouse       = true;
    baseIndex   = 1;
    escapeTime  = 10;
    keyMode     = "vi";
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
      bind-key r source-file ~/.config/tmux/.tmux.conf \; display "Reloaded Tmux Config"
      bind-key -T copy-mode-vi v   send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-selection
      bind-key -T copy-mode-vi y   send-keys -X copy-selection-and-cancel

      set-option -sa terminal-features ',alacritty:RGB'
      set-option -ga terminal-overrides ",xterm-256color:Tc"
      set-option -g  default-terminal "tmux-256color"
      set-option -ga terminal-features ",alacritty:usstyle"
    '';
  };

  programs.starship = {
    enable              = true;
    enableZshIntegration = true;
    settings            = {};
  };

  programs.zoxide.enable  = true;
  programs.lazygit.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "Fabio Baser";
        email = "git@fabiobaser.de";
      };
      init.defaultBranch    = "main";
      push = {
        default          = "simple";
        autoSetupRemote  = true;
        followTags       = true;
      };
      fetch = {
        prune     = true;
        pruneTags = true;
        all       = true;
      };
    };
  };

  programs.home-manager.enable = true;
}
