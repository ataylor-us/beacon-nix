default: deploy switch

deploy:
    scp configuration.nix alex@beacon.internal:beacon-nix/configuration.nix

switch: ups-secret
    ssh -t alex@beacon.internal 'sudo install -m 600 -o root -g root nut-password /root/nut-password && rm nut-password && sudo nixos-rebuild switch'

ups-secret:
    pass show Repositories/beacon-nix/livingroom-ups | head -n1 | ssh alex@beacon.internal 'umask 077 && cat > nut-password'
