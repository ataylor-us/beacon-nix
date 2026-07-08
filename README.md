# beacon-nix

This is my nix ([NixOS](https://nixos.org/)) config.

Currently, this box (a Beelink Mini S12 Pro, N100) hosts an instance of [Uptime-Kuma](https://uptime.kuma.pet/). Eventually, I plan on migrating my Home Assistant container to a [Home Assistant VM](https://www.home-assistant.io/installation/linux/) on here.

## Deploying

The nix configuration files are currently symlinked into `~/beacon-nix/`.

```bash
# scp nix file
just deploy
# rebuild
just switch
```
