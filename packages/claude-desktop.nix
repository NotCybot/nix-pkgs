{
  stdenv,
  fetchurl,
  gtk3,
  libnotify,
  nss,
  xdg-utils,
  at-spi2-core,
  libdrm,
  libxcb,
  libsecret,
  gvfs,
  glibc,
  libXtst,
  dpkg,
  autoPatchelfHook,
  libgbm,
  alsa-lib,
  libseccomp,
  libcap_ng,
  lib,
  libGL,
  pipewire,
}:

stdenv.mkDerivation rec {
  pname = "claude-desktop";
  # curl -s https://downloads.claude.ai/claude-desktop/apt/stable/dists/stable/main/binary-amd64/Packages | grep Version:
  version = "2.42304.0";

  src = fetchurl {
    url = "https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_${version}_amd64.deb";
    hash = "sha256-dM0szCnSQWUUTkVcvIcsbMKiSiY7g+c0IOlfiRZtSqQ=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    gtk3
    libnotify
    nss
    xdg-utils
    at-spi2-core
    libdrm
    libxcb
    libsecret
    gvfs
    glibc
    libXtst
    libgbm
    alsa-lib
    libseccomp
    libcap_ng
    pipewire
  ];

  installPhase = ''
    runHook preInstall

    cp -r usr $out

    runHook postInstall
  '';

  preFixup = ''
    patchelf --add-needed libEGL.so.1 \
      --add-rpath ${
        lib.makeLibraryPath [
          libGL
        ]
      } $out/bin/claude-desktop
  '';

  meta = {
    description = "Claude Desktop Application";
    homepage = "https://claude.ai/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
