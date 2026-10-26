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

    corona = {
      url = "github:profiidev/corona";
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
      inherit (nixpkgs) lib;
      overlay = import ./overlay.nix inputs;
      buildList = import ./packages.nix;
      systems = lib.unique (buildList.auto ++ builtins.attrNames buildList.extra);
    in
    {
      overlays.default = overlay.default;

      packages = lib.genAttrs systems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ overlay.default ];
          };
          auto = lib.optionals (builtins.elem system buildList.auto) (
            builtins.filter (name: lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.${name}) (
              overlay.names pkgs
            )
          );
        in
        lib.genAttrs (auto ++ buildList.extra.${system} or [ ]) (
          name: lib.getAttrFromPath (lib.splitString "." name) pkgs
        )
      );

      # nix-config imports modules from these
      inherit (inputs) hyprland vicinae corona;
    };
}
