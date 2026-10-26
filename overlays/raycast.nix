{ mkRayCastExtension, ... }:
final: prev:

let
  rev = "8a2c73ff4315ff30c2ed1d08384dc8d35df32305";

  src =
    dir: hash:
    "${
      final.fetchFromGitHub {
        owner = "raycast";
        repo = "extensions";
        inherit rev hash;
        sparseCheckout = [ "extensions/${dir}" ];
      }
    }/extensions/${dir}";

  # attribute name = { dir in raycast/extensions; source hash }
  extensions = {
    home-assistant-vicinae-extension = src "homeassistant" "sha256-lSEtzYw96imTNHNW/VxxZZxyhOP6q490YnV8fYdpt3Y=";
    google-vicinae-extension = src "google-search" "sha256-L1uXvVu640AIm+FUMYKxZ0mnvwpA6cAdJpOPBvnbtuk=";
    spotify-player-vicinae-extension = src "spotify-player" "sha256-atPAUm3eqVUUepfAs/N3lOs2G2qHztKHvn6cL9GD+GU=";
    whois-vicinae-extension = src "whois" "sha256-hbbsado3rTNVR/jjFt5JvCTAaUMY5IlMuYGnv0WZz+M=";
    random-data-generator = src "random-data-generator" "sha256-taa3pg69aVF0GO7jXnR2gpRZVBJUqnlYlkPxaYT21qI=";
    qrcode-generator = src "qrcode-generator" "sha256-6gmc96Y5zTRzTcGvjQsOmn/P89HV8PmmpTDxdK7oYD0=";
    can-i-use = src "can-i-use" "sha256-KKuYr34JG6V0Dn0Ekf/RNoU7tCPDgg8WrYASAmiuO4A=";
    lucide-icons-search = src "lucide-icons" "sha256-kS92gdtBzPf9SOdE6OtGDf2Fo69tIlusDGOwaEcwPbo=";
    jwt-decoder = src "jwt-decoder" "sha256-+bxaGQdNA6Cq8zq30mnmvnixjVwCgVTqmM/6jl+yC8M=";
    search-mdn = final.applyPatches {
      name = "search-mdn-src";
      src = src "search-mdn" "sha256-FNRbJuyBqM+k6SNkEzdMz9vfNsNgiq1kdKRlzPDSMsg=";
      patches = [ ../patches/search-mdn.patch ];
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-aTtVzjAQ78k8fR6xc1i6jxXY35ZtMfTStnKj/Heh6/k=";
    };
  };
in
prev.lib.mapAttrs (
  name: src:
  mkRayCastExtension {
    inherit name src;
    version = "0.1.0";
  }
) extensions
