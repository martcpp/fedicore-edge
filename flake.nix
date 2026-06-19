{
  description = "Offline NixOS generation switch + rollback proof (NixOS-WSL)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }:
    let
      mkSystem = extraPackages: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          ({ pkgs, ... }: {
            wsl.enable = true;
            wsl.defaultUser = "nixos";

            # Match your installed system. Check with:  nixos-version
            system.stateVersion = "26.05";

            # Keep flakes enabled declaratively so a system switch does NOT
            # overwrite it. (This is why the first rollback failed before.)
            nix.settings.experimental-features = [ "nix-command" "flakes" ];

            environment.systemPackages = extraPackages pkgs;
          })
        ];
      };
    in {
      # Generation A: baseline, no extra package.
      nixosConfigurations.edge-a = mkSystem (pkgs: [ ]);

      # Generation B: adds 'cowsay' so the two generations differ visibly.
      nixosConfigurations.edge-b = mkSystem (pkgs: [ pkgs.cowsay ]);
    };
}
