# Fedicore-Edge

**Fedicore-Edge** is a Rust orchestration agent and NixOS flake for offline-first deployment
of self-hosted edge infrastructure, developing coordinated, cross-plane atomic rollback
(system + database schema + data) as its core contribution.

This project is developed by Mordecai Etukudo and field-tested in collaboration with the
**Rust Africa** community, to keep decentralized Fediverse nodes highly available in power and
connectivity-constrained environments.

## Status

**Working today** (see proof below): offline-first deployment and offline rollback of NixOS
system generations.

**Proposed **: coordinated cross-plane rollback that restores system, database
schema, and data as a single transaction; crash-consistent recovery on boot; and an explicit
bounded-data-loss policy for the rollback window.

## Architecture proof of concept

This repository holds the offline-Nix deployment proof of concept
(`offline-proof-20260619-155058.log`), demonstrating switching and rolling back NixOS system
generations **entirely offline**, using a pre-staged local closure with the network forbidden
(`--offline`). A signed local binary cache (for true cross-machine pre-staging) is part of
Milestone 1.

- **`flake.nix`** — declarative configuration defining two system generations for the offline
  switch/rollback demo.
- **`demo.sh`** — execution script that pre-stages a closure, then performs the generation
  switch and rollback with the network forbidden, and writes a timestamped proof log.
- **`offline-proof-20260619-155058.log`** — recorded output of a full offline switch + rollback
  run.

### Reproduce it

Run inside a NixOS system (for example NixOS-WSL):

```
chmod +x demo.sh
./demo.sh
```

Steps 1-2 fetch and build once (online); steps 3-5 use no network.

## Licensing

To protect the digital commons and keep infrastructure modifications open, the core
Fedicore-Edge orchestration agent is licensed under the **GNU Affero General Public License
v3.0 (AGPL-3.0)**.

*The coordinated-rollback engine may later be decoupled and released under a permissive
Apache-2.0 license to maximize reuse across other stateful systems, while the Fediverse agent
itself remains AGPL-3.0.*
