# beacon-nix

This is my nix ([NixOS](https://nixos.org/)) config.

Currently, this box (a Beelink Mini EQ12, N100) hosts an instance of [Uptime-Kuma](https://uptime.kuma.pet/), an [AdGuardHome](https://github.com/AdguardTeam/AdGuardHome) instance, and a VM of the [Home Assistant Operating System](https://developers.home-assistant.io/docs/operating-system/).

The VM is run using KVM (via libvirt) as the hypervisor. It uses a separate physical port for the bridge.

This AdGuardHome instance is used as a custom DNS server for my [tailnet](https://tailscale.com/docs/concepts/tailnet).

The hard drive is encrypted by LUKS, with the key loaded from a flash drive attached to it during boot.

## Deploying

The nix configuration files are currently symlinked into `~/beacon-nix/`.

```bash
# scp nix file & rebuild
just
```
