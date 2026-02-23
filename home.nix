{ config, pkgs, ... }:

{
  home.username = "fabiobaser";
  home.homeDirectory = "/home/fabiobaser";
  home.stateVersion = "25.11";
  home.packages = [
    pkgs.neovim
    pkgs.gh
    pkgs.bat
    pkgs.eza
    pkgs.ripgrep
    # JavaScript Stuff
    pkgs.bun
    pkgs.pnpm
    # Libs
    pkgs.gnumake
    pkgs.gcc
    pkgs.cargo
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {
    ".config/nvim" = {
      source= ~/dotfiles/nvim;
      recursive = true;
    };
    # ".tmux.conf".source = ~/dotfiles/.tmux.conf;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };


  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      size = 99999; # increase history size to keep (default: 2000)
      saveNoDups = true; # don't save duplicate entries
      append = true; # zsh session will append ther history instead of replacing it
    };
    shellAliases = {
      c = "clear";
      v = "nvim";
      # home-manager Management
      hm = "home-manager";
      hms = "home-manager switch";
      hmc = "nvim ~/.config/home-manager/home.nix";
      # zsh Management
      zshrc = "nvim ~/.zshrc";
      zshreload = "source ~/.zshrc";
      # Eza Aliases
      l = "eza -T -L 1 --icons --group-directories-first -I .git";
      la = "eza -T -L 1 --icons -a --group-directories-first -I .git";
      ll = "eza -T -L 2 --icons --group-directories-first -I .git";
      lla = "eza -T -L 2 --icons -a --group-directories-first -I .git";
      lll = "eza -T -L 3 --icons --group-directories-first -I .git";
      # Lazy
      lg = "lazygit";
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true; # Enable Mouse Support
    baseIndex = 1; # Base Index for windows and panes
    escapeTime = 10; # Milliseconds tmux waits after an escape is input
    keyMode = "vi";
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
          # Smart pane switching with awareness of Vim splits.
          # See: https://github.com/christoomey/vim-tmux-navigator
          vim_pattern='(\S+/)?g?\.?(view|l?n?vim?x?|fzf)(diff)?(-wrapped)?'
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
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Proper colors
      set-option -sa terminal-features ',alacritty:RGB'
      set-option -ga terminal-overrides ",xterm-256color:Tc"


      # Undercurl
      set-option -g default-terminal "tmux-256color"
      set-option -ga terminal-features ",alacritty:usstyle"
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {};
  };

  programs.zoxide = {
    enable = true;
  };

  programs.lazygit = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Fabio Baser";
        email = "git@fabiobaser.de";
      };
      init = {
        defaultBranch = "main";
      };
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
