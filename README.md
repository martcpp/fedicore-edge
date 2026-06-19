# Fedicore-Edge

**Fedicore-Edge** is a Rust orchestration agent and NixOS flake providing offline-first deployment and coordinated, cross-plane atomic rollbacks for self-hosted edge infrastructure. 

This project is developed by Mordecai Etukudo and field-tested in collaboration with the **Rust Africa** community to ensure high availability for decentralized Fediverse nodes operating in power- and connectivity-constrained environments.

## Architecture Proof of Concept
This repository currently holds the offline-Nix deployment proof of concept (`offline-proof-20260619-155058.log`), demonstrating the capability to switch and roll back NixOS system generations entirely offline using a local binary cache. 

* **`flake.nix`**: The declarative configuration pinning the local deployment state.
* **`demo.sh`**: The execution script validating the offline generation switch and rollback mechanism.

## Licensing Strategy
To protect the digital commons and ensure that infrastructure modifications remain open, the core Fedicore-Edge orchestration agent is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**. 

*(Note: In the future, the underlying coordinated-rollback Rust engine may be decoupled and released under a permissive Apache-2.0 license to maximize reuse across broader stateful ecosystems, while the Fediverse agent itself remains firmly AGPL-3.0).*
