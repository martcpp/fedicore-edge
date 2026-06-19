#!/usr/bin/env bash
# Offline NixOS switch + rollback proof.
# Run INSIDE NixOS-WSL, from the folder that contains flake.nix.
# Steps 1-2 need internet (fetch + build once). Steps 3-5 use no network.

set -euo pipefail

LOG="offline-proof-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee "$LOG") 2>&1

COWSAY=/run/current-system/sw/bin/cowsay
SYSPROFILE=/nix/var/nix/profiles/system

echo "============================================================"
echo " Offline NixOS generation switch + rollback proof"
echo " Host: $(hostname)   User: $(whoami)"
date
echo "============================================================"
echo

echo "[1/5] ONLINE: set baseline to Generation A (no cowsay)."
sudo nixos-rebuild switch --flake .#edge-a
[ -e "$COWSAY" ] && echo "      cowsay present? -> yes (unexpected)" || echo "      cowsay present? -> no (correct)"
echo

echo "[2/5] ONLINE: pre-stage Generation B's closure into local /nix/store (build only)."
sudo nixos-rebuild build --flake .#edge-b
echo

echo "[3/5] PROOF OF STAGING: build Gen B again with the network FORBIDDEN."
sudo nixos-rebuild build --flake .#edge-b --offline --option substituters ""
echo "      -> succeeded with --offline, nothing was missing locally."
echo

echo "[4/5] OFFLINE: switch to Generation B with the network FORBIDDEN."
sudo nixos-rebuild switch --flake .#edge-b --offline --option substituters ""
if [ -e "$COWSAY" ]; then
  echo "      cowsay present? -> yes (correct)"
  "$COWSAY" "offline switch worked"
else
  echo "      cowsay present? -> NO (unexpected)"
fi
echo

echo "[5/5] OFFLINE: roll back to the previous generation (A)."
echo "      Pure local activation: no network, no rebuild, no flake evaluation."
sudo nix-env --profile "$SYSPROFILE" --rollback
sudo "$SYSPROFILE"/bin/switch-to-configuration switch
[ -e "$COWSAY" ] && echo "      cowsay present? -> still here (unexpected)" || echo "      cowsay present? -> gone (correct, rollback worked)"
echo

echo "------------------------------------------------------------"
echo "Generation history:"
sudo nix-env --list-generations --profile "$SYSPROFILE" || true
echo "------------------------------------------------------------"
date
echo "DONE. Proof log saved to: $LOG"
