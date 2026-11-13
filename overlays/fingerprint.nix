_: final: prev:

{
  libfprint-sigfm = prev.libfprint.overrideAttrs (old: {
    version = "1.94.5-sigfm";
    src = final.fetchFromGitHub {
      owner = "goodix-fp-linux-dev";
      repo = "libfprint";
      rev = "07306bbc9256942595e31fb0f407b364ffa24d07";
      hash = "sha256-HNFR+5kWHhG4inIn1An4aJ1RoieHbNh5aiTW0g5hAV0=";
    };
    patches = [ ../patches/elanspi-sigfm.patch ];
    postPatch = ''
      substituteInPlace meson.build --replace-fail "version: '1.94.5'" "version: '1.94.9'"
      substituteInPlace libfprint/fp-device.h --replace-fail \
        '  FP_DEVICE_RETRY_REMOVE_FINGER,' \
        '  FP_DEVICE_RETRY_REMOVE_FINGER,
        FP_DEVICE_RETRY_TOO_FAST,'
    '';
    mesonFlags = map (
      f: if prev.lib.hasPrefix "-Ddrivers=" f then "-Ddrivers=elanspi" else f
    ) old.mesonFlags;
    buildInputs = old.buildInputs ++ [
      final.nss
      final.opencv
      final.doctest
    ];
    postInstall = "install -Dm644 ../libfprint/sigfm/sigfm.hpp $out/include/libfprint-2/sigfm/sigfm.hpp    ";
    doInstallCheck = false;
  });

  fprintd-sigfm = prev.fprintd.override { libfprint = final.libfprint-sigfm; };
}
