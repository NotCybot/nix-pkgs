# What CI builds and pushes. On `auto` systems that is everything from overlays/ and packages/
# whose meta.platforms fits, plus `extra`; elsewhere only `extra`.
# Anything else from the overlay still works, it just isn't cached.
{
  auto = [ "x86_64-linux" ];

  extra = {
    x86_64-linux = [
      "linuxPackages.nvidiaPackages.latest" # meitner
      "linuxPackages.nvidiaPackages.legacy_580" # kopernikus
    ];

    aarch64-darwin = [
      "hibernation"
      "lixPackageSets.latest.lix"
      "webots"
      "vicinae-vscode-recents" # mbp, linked by home.gui.vicinae
    ];
  };
}
