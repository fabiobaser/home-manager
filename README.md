# nix-home

Personal system config for **macOS** (nix-darwin + home-manager) and **Linux/WSL2** (home-manager standalone).

---

## Structure

```
.
├── flake.nix                   # Entry point — defines all system configs
├── dotfiles/
│   ├── nvim/                   # Neovim config (symlinked, editable live)
│   └── tmuxinator/             # Tmuxinator sessions (symlinked, editable live)
└── modules/
    ├── home/
    │   ├── base.nix            # Shared: packages, shell, git, tmux, starship
    │   ├── darwin.nix          # macOS home extras: Finder/Dock defaults, osxkeychain
    │   └── linux.nix           # Linux/WSL2 extras: wslu, clipboard bridge, git credential manager
    └── darwin/
        └── system.nix          # nix-darwin system config: Homebrew casks, system defaults, user setup
```

### Why this split?

| File | Manages |
|---|---|
| `home/base.nix` | Everything that's the same on both platforms — CLI tools, zsh, git, tmux, starship |
| `home/darwin.nix` | macOS-specific home config — `targets.darwin.defaults`, credential helper |
| `home/linux.nix` | WSL2-specific home config — `wslview`, clipboard, Windows Git Credential Manager |
| `darwin/system.nix` | System-level macOS config via nix-darwin — Homebrew casks, system defaults, user shell |

`dotfiles/` are symlinked via `mkOutOfStoreSymlink` — meaning you can edit them directly without running a switch.

---

## Applying

### macOS

#### First time (bootstrap nix-darwin)

```bash
# Install Nix if not already done
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Bootstrap nix-darwin
nix run nix-darwin -- switch --flake ~/.config/home-manager#fabiobaser-mac
```

#### After that

```bash
darwin-rebuild switch --flake ~/.config/home-manager#fabiobaser-mac
```

---

### Linux / WSL2

#### First time

```bash
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Install home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Apply config
home-manager switch --flake ~/.config/home-manager#fabiobaser-linux
```

#### After that

```bash
home-manager switch --flake ~/.config/home-manager#fabiobaser-linux
```

---

## Adding packages

**Shared (both platforms)** → `modules/home/base.nix` under `home.packages`

**macOS only (nixpkgs)** → `modules/home/darwin.nix` under `home.packages`

**macOS only (casks/brews)** → `modules/darwin/system.nix` under `homebrew.casks` / `homebrew.brews`

**Linux only** → `modules/home/linux.nix` under `home.packages`

---

## Dotfiles

Neovim and Tmuxinator configs live in `dotfiles/` and are symlinked directly — no copy into the Nix store. Edit them in place, changes take effect immediately.

```
dotfiles/nvim/       → ~/.config/nvim
dotfiles/tmuxinator/ → ~/.config/tmuxinator
```

To add more live-editable dotfiles, use `mkOutOfStoreSymlink` in `base.nix`:

```nix
home.file.".config/something" = {
  source = config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/.config/home-manager/dotfiles/something";
};
```

---

## Useful aliases

| Alias | Command |
|---|---|
| `hm` | `home-manager` |
| `hms` | `home-manager switch` |
| `hmc` | Open `home.nix` in nvim |
| `lg` | lazygit |
| `v` | nvim |
