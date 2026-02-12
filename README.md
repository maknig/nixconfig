# NixOS & Home Manager Configs

A declarative configuration for several NixOS hosts and Home Manager
set‑ups, using a single flake. The flake pulls packages from **unstable** channel, adds the `neovim-nightly-overlay`, and
includes a collection of Neovim plugins as inputs.

## Repository layout

```
flake.nix           # main flake entry point
lib/                # helper functions imported by the flake
home-manager/       # Home Manager modules
nixos/              # NixOS
```

## Prerequisites

- Nix ≥ 2.20 with flakes enabled (`experimental-features = nix-command flakes` in `/etc/nix/nix.conf`).
- NixOS or Home Manager

## Clone the repository

```bash
git clone https://github.com/maknig/nixconfig.git
cd nixconfig


```

## Enable flakes

```bash
echo "extra-experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

## Activating a NixOS configuration

```bash
sudo nixos-rebuild switch --flake .#<host>
```

## Activating a Home Manager configuration

```bash
home-manager switch --flake .#<host>
```

## Resources

- [home-manger manual][home-manager-man]
- [nix manual][nix-man]
- [nixOS manual][nixos-man]
- [nixpkgs][nixpkgs-man]

[home-manager-man]: https://nix-community.github.io/home-manager/
[nix-man]: https://nixos.org/manual/nix/stable/
[nixpkgs-man]: https://nixos.org/manual/nixpkgs/stable/
[nixos-man]: https://nixos.org/manual/nixos/stable/
[determinate-systems]: https://determinate.systems/nix-installer/
