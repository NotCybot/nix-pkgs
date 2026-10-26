# nix-pkgs

Custom packages and overlay, built by CI and pushed to a Hibernation cache over Tailscale.


## Struktur

| Pfad | Inhalt |
|---|---|
| `flake.nix` | Inputs, `overlays.default`, `packages.<system>` (das baut die CI) |
| `overlay.nix` | lädt `overlays/*.nix` und `packages/*.nix` automatisch |
| `overlays/` | ein Thema pro Datei, Form `{ inputs, mkRayCastExtension, ... }: final: prev: { … }` — Pakete aus Flake-Inputs (`inputs.nix`), Raycast-Extensions (`raycast.nix`), CUDA-Varianten (`cuda.nix`), Overrides von nixpkgs-Paketen (`vscode.nix`) |
| `packages/` | eigene Derivations, eine pro Datei, Attributname = Dateiname, per `callPackage` (bekommt zusätzlich `inputs` und `mkRayCastExtension`) |
| `patches/` | Patches, referenziert aus `overlays/` bzw. `packages/` |
| `packages.nix` | Build-Liste: auf `auto`-Systemen alles aus `overlays/` und `packages/`, das laut `meta.platforms` passt, plus `extra`; sonst nur `extra` |

Neues Paket: Datei in `packages/` (oder Eintrag in einem Overlay) anlegen, fertig — auf x86_64-linux baut die CI es automatisch. Für andere Systeme den Namen unter `extra` eintragen.

## Secrets

| Secret | Value |
|---|---|
| `HIBERNATION_URL` | Cache base URL, no trailing `/` |
| `HIBERNATION_TOKEN` | Token of a Hibernation user with edit access to cache `main` |
| `HIBERNATION_SIGNING_KEY` | Secret signing key of the cache |
| `TS_OAUTH_CLIENT_ID`, `TS_AUDIENCE` | Tailscale OIDC trust credential: issuer GitHub, subject `repo:NotCybot@141260979/nix-pkgs@1422165276:*` (GitHub uses owner/repo IDs in `sub`), Auth Keys write, tag `tag:ci` |
| `RENOVATE_APP_CLIENT_ID`, `RENOVATE_APP_PRIVATE_KEY` | GitHub App installed on this repo (Renovate and the weekly `flake.lock` PR), contents and pull requests write |

## Usage

```nix
inputs.custom-nixpkgs.url = "github:NotCybot/nix-pkgs";

nixpkgs.overlays = [ inputs.custom-nixpkgs.overlays.default ];
```

Add the cache as substituter with its public key. What CI builds: see `packages.nix`.

Cache hits need the same nixpkgs commit as this repo's `flake.lock`: `flake.lock` is updated by a PR every Monday (`lock-update.yml`), update the consuming flake after it is merged.
