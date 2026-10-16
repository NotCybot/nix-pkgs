{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "webots";
  # ponytail: nightly from master, R2025a dmg doesn't start on macOS 27 (cyberbotics/webots#6977,
  # fixed in #7032). Back to a release tag once one contains the fix. Nightlies get deleted, the
  # cache keeps the dmg.
  version = "nightly_15_10_2026";

  src = fetchurl {
    url = "https://github.com/cyberbotics/webots/releases/download/${finalAttrs.version}/webots-R2025a.dmg";
    hash = "sha256-4b76SN7lzvq5FacDw3iFq0HwR85B8eeOVf+DND9xRY4=";
  };

  nativeBuildInputs = [ undmg ];
  sourceRoot = ".";

  # signed bundle, any fixup would break the signature
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R Webots.app $out/Applications/
    runHook postInstall
  '';

  meta = {
    description = "Open source robot simulator";
    homepage = "https://cyberbotics.com";
    license = lib.licenses.asl20;
    platforms = lib.platforms.darwin;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
