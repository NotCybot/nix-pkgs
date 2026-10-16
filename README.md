# nix-pkgs

Custom packages and overlay, built by CI and pushed to a Hibernation cache over Tailscale.

## Secrets

| Secret | Value |
|---|---|
| `HIBERNATION_URL` | Cache base URL, no trailing `/` |
| `HIBERNATION_TOKEN` | Token of a Hibernation user with edit access to cache `main` |
| `HIBERNATION_SIGNING_KEY` | Secret signing key of the cache |
| `TS_OAUTH_CLIENT_ID`, `TS_AUDIENCE` | Tailscale OIDC trust credential: issuer GitHub, subject `repo:NotCybot@141260979/nix-pkgs@1422165276:*` (GitHub uses owner/repo IDs in `sub`), Auth Keys write, tag `tag:ci` |
| `RENOVATE_APP_CLIENT_ID`, `RENOVATE_APP_PRIVATE_KEY` | GitHub App installed on this repo |

## Usage

```nix
inputs.custom-nixpkgs.url = "github:NotCybot/nix-pkgs";

nixpkgs.overlays = [ inputs.custom-nixpkgs.overlays.default ];
```

Add the cache as substituter with its public key. What CI builds: `packages.nix`.

Cache hits need the same nixpkgs commit as this repo's `flake.lock`: update both locks together.
