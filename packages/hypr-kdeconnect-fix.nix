{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wayland-scanner,
  libxkbcommon,
  wayland,
  libei,
  qt6,
}:

stdenv.mkDerivation {
  pname = "hypr-kdeconnect-fix";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "gfhdhytghd";
    repo = "hypr-kdeconnect-fix";
    rev = "e86a0fb17826cb8ea987665ded7428534e4a1a9d";
    hash = "sha256-VcXxVtlnkPjO6l0ky/n+0qa87Uc3c8hRM0twfgl+AiM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];

  dontWrapQtApps = true;

  buildInputs = [
    libei
    libxkbcommon
    qt6.qtbase
    wayland
  ];
}
