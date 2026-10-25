_: _final: prev:

{
  # Electron is Wayland-native by default; NIXOS_OZONE_WL only adds flags that trigger CLI warnings
  vscode =
    if prev.stdenv.hostPlatform.isLinux then
      prev.vscode.overrideAttrs (old: {
        preFixup = (old.preFixup or "") + ''
          gappsWrapperArgs+=(--unset NIXOS_OZONE_WL)
        '';
      })
    else
      prev.vscode;
}
