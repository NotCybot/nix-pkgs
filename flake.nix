{
  description = "Custom packages for nix-config, built by CI and pushed to the Hibernation cache";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    soulver-cpp = {
      url = "github:vicinaehq/soulver-cpp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        soulver-cpp.follows = "soulver-cpp";
      };
    };

    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        vicinae.follows = "vicinae";
        systems.follows = "systems";
      };
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hibernation = {
      url = "github:profiidev/hibernation/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      overlay = import ./overlay.nix inputs;
      buildList = import ./packages.nix;
    in
    {
      overlays.default = overlay;

      packages = nixpkgs.lib.mapAttrs (
        system: names:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ overlay ];
          };
        in
        nixpkgs.lib.genAttrs names (name: pkgs.${name})
      ) buildList;

      # nix-config imports modules from these
      inherit (inputs) hyprland vicinae noctalia;
    };
}
