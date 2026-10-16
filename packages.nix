# What CI builds and pushes per system. Everything else from the overlay is still usable,
# it just isn't cached.
{
  x86_64-linux = [
    "hyprland"
    "xdg-desktop-portal-hyprland"
    "noctalia"
    "vicinae-with-soulver"
    "vicinae-nix"
    "vicinae-power-profile"
    "vicinae-it-tools"
    "vicinae-port-killer"
    "vicinae-hypr-keybinds"
    "vicinae-vscode-recents"
    "vicinae-protondb-search"
    "vicinae-jetbrains-recent-projects"
    "vicinae-hyprland-monitors"
    "vicinae-hypr"
    "vicinae-timer"
    "vicinae-npm"
    "home-assistant-vicinae-extension"
    "google-vicinae-extension"
    "spotify-player-vicinae-extension"
    "whois-vicinae-extension"
    "random-data-generator"
    "qrcode-generator"
    "can-i-use"
    "lucide-icons-search"
    "search-mdn"
    "hypr-kdeconnect-fix"
    "hibernation"
    "ollama-cuda"
    "linuxPackages.nvidiaPackages.latest" # meitner
    "linuxPackages.nvidiaPackages.legacy_580" # kopernikus
  ];

  aarch64-darwin = [
    "hibernation"
    "lixPackageSets.latest.lix"
    "webots"
  ];
}
