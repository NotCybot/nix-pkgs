# overlays/*.nix change or add packages from nixpkgs and flake inputs, packages/*.nix are
# derivations of our own, one per file. Both are picked up automatically.
inputs:

let
  inherit (inputs.nixpkgs) lib;

  nixFiles =
    dir:
    lib.mapAttrs' (file: _: lib.nameValuePair (lib.removeSuffix ".nix" file) (dir + "/${file}")) (
      lib.filterAttrs (file: type: type == "regular" && lib.hasSuffix ".nix" file) (builtins.readDir dir)
    );

  own =
    final: prev:
    let
      inherit (prev.stdenv.hostPlatform) system;

      # Raycast extensions build with `ray build`; the default buildPhase's --out flag doesn't reach ray
      mkRayCastExtension =
        args:
        (inputs.vicinae.lib.${system}.mkVicinaeExtension args).overrideAttrs (_: {
          buildPhase = "npm run build -- -o=$out";
        });

      args = { inherit inputs mkRayCastExtension; };
    in
    lib.foldl' (acc: file: acc // import file args final prev) { } (
      builtins.attrValues (nixFiles ./overlays)
    )
    // lib.mapAttrs (_: file: lib.callPackageWith (final // args) file { }) (nixFiles ./packages);
in
{
  default = final: prev: inputs.vicinae.overlays.default final prev // own final prev;

  # everything this repo defines itself, CI builds it on the systems listed in packages.nix
  names = pkgs: builtins.attrNames (own pkgs pkgs);
}
