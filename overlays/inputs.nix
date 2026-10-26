{ inputs, ... }:
final: prev:

let
  inherit (prev.stdenv.hostPlatform) system;

  vicinaeExtensions = [
    "nix"
    "power-profile"
    "it-tools"
    "port-killer"
    "hypr-keybinds"
    "protondb-search"
    "jetbrains-recent-projects"
    "hyprland-monitors"
    "hypr"
    "timer"
    "npm"
  ];

  # upstream pins gcc15Stdenv; build with the default stdenv so its libstdc++ matches soulver
  vicinaeDefaultStdenv = inputs.vicinae.packages.${system}.default.override {
    gcc15Stdenv = final.stdenv;
  };
  soulver = inputs.soulver-cpp.packages.${system}.default;
in
prev.lib.genAttrs' vicinaeExtensions (
  ext: prev.lib.nameValuePair "vicinae-${ext}" inputs.vicinae-extensions.packages.${system}.${ext}
)
// {
  inherit (inputs.hyprland.packages.${system}) hyprland xdg-desktop-portal-hyprland;
  hibernation = inputs.hibernation.packages.${system}.default;
  corona = inputs.corona.packages.${system}.default;

  # VS Code 1.13x dropped history.recentlyOpenedPathsList, fall back to the storage.json menu cache
  vicinae-vscode-recents =
    inputs.vicinae-extensions.packages.${system}.vscode-recents.overrideAttrs
      (old: {
        patches = (old.patches or [ ]) ++ [ ../patches/vicinae-vscode-recents.patch ];
      });

  vicinae-with-soulver = final.symlinkJoin {
    name = "${vicinaeDefaultStdenv.name}-with-soulver";
    paths = [ vicinaeDefaultStdenv ];
    nativeBuildInputs = [ final.makeWrapper ];
    postBuild = ''
      for bin in $out/bin/*; do
        wrapProgram "$bin" \
          --prefix LD_LIBRARY_PATH : ${soulver}/lib \
          --prefix XDG_DATA_DIRS : ${soulver}/share
      done
    '';
    inherit (vicinaeDefaultStdenv) meta;
  };
}
