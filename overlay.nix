inputs: final: prev:

let
  inherit (prev.stdenv.hostPlatform) system;

  vicinaeExtensions = [
    "nix"
    "power-profile"
    "it-tools"
    "port-killer"
    "hypr-keybinds"
    "vscode-recents"
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

  # Raycast extensions build with `ray build`; the default buildPhase's --out flag doesn't reach ray
  mkRayCastExtension =
    args:
    (inputs.vicinae.lib.${system}.mkVicinaeExtension args).overrideAttrs (_: {
      buildPhase = "npm run build -- -o=$out";
    });

  raycastSrc =
    dir: hash:
    "${
      final.fetchFromGitHub {
        owner = "raycast";
        repo = "extensions";
        rev = "8a2c73ff4315ff30c2ed1d08384dc8d35df32305";
        sparseCheckout = [ "extensions/${dir}" ];
        inherit hash;
      }
    }/extensions/${dir}";

  raycast =
    name: src:
    mkRayCastExtension {
      inherit name src;
      version = "0.1.0";
    };

  externalPkgs =
    inputs.vicinae.overlays.default final prev // inputs.noctalia.overlays.default final prev;
in
externalPkgs
// prev.lib.genAttrs' vicinaeExtensions (
  ext: prev.lib.nameValuePair "vicinae-${ext}" inputs.vicinae-extensions.packages.${system}.${ext}
)
// {
  inherit (inputs.hyprland.packages.${system}) hyprland xdg-desktop-portal-hyprland;
  hibernation = inputs.hibernation.packages.${system}.default;

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

  hypr-kdeconnect-fix = final.callPackage ./packages/hypr-kdeconnect-fix.nix { };
  claude-desktop = final.callPackage ./packages/claude-desktop.nix { };
  webots = final.callPackage ./packages/webots.nix { };

  home-assistant-vicinae-extension = raycast "home-assistant-vicinae-extension" (
    raycastSrc "homeassistant" "sha256-lSEtzYw96imTNHNW/VxxZZxyhOP6q490YnV8fYdpt3Y="
  );
  google-vicinae-extension = raycast "google-vicinae-extension" (
    raycastSrc "google-search" "sha256-L1uXvVu640AIm+FUMYKxZ0mnvwpA6cAdJpOPBvnbtuk="
  );
  spotify-player-vicinae-extension = raycast "spotify-player-vicinae-extension" (
    raycastSrc "spotify-player" "sha256-atPAUm3eqVUUepfAs/N3lOs2G2qHztKHvn6cL9GD+GU="
  );
  whois-vicinae-extension = raycast "whois-vicinae-extension" (
    raycastSrc "whois" "sha256-hbbsado3rTNVR/jjFt5JvCTAaUMY5IlMuYGnv0WZz+M="
  );
  random-data-generator = raycast "random-data-generator" (
    raycastSrc "random-data-generator" "sha256-taa3pg69aVF0GO7jXnR2gpRZVBJUqnlYlkPxaYT21qI="
  );
  qrcode-generator = raycast "qrcode-generator" (
    raycastSrc "qrcode-generator" "sha256-6gmc96Y5zTRzTcGvjQsOmn/P89HV8PmmpTDxdK7oYD0="
  );
  can-i-use = raycast "can-i-use" (
    raycastSrc "can-i-use" "sha256-KKuYr34JG6V0Dn0Ekf/RNoU7tCPDgg8WrYASAmiuO4A="
  );
  lucide-icons-search = raycast "lucide-icons-search" (
    raycastSrc "lucide-icons" "sha256-kS92gdtBzPf9SOdE6OtGDf2Fo69tIlusDGOwaEcwPbo="
  );
  search-mdn = raycast "search-mdn" (
    final.applyPatches {
      name = "search-mdn-src";
      src = raycastSrc "search-mdn" "sha256-FNRbJuyBqM+k6SNkEzdMz9vfNsNgiq1kdKRlzPDSMsg=";
      patches = [ ./patches/search-mdn.patch ];
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-aTtVzjAQ78k8fR6xc1i6jxXY35ZtMfTStnKj/Heh6/k=";
    }
  );
}
