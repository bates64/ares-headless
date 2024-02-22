{
  lib,
  stdenv,
  pkg-config,
  which,
  wrapGAppsHook,
  alsa-lib,
  SDL2,
  libao,
  libicns,
  gtk3,
  gtksourceview3,
  libGL,
  libGLU,
  libX11,
  libXv,
  libpulseaudio,
  openal,
  udev,
  darwin,
  self,
}:

stdenv.mkDerivation {
  pname = "ares";
  version = "135";

  src = self;

  nativeBuildInputs = [
    pkg-config
    which
    wrapGAppsHook
  ] ++ lib.optionals stdenv.isDarwin [ libicns ];

  buildInputs =
    [
      SDL2
      libao
    ]
    ++ lib.optionals stdenv.isLinux [
      alsa-lib
      gtk3
      gtksourceview3
      libGL
      libGLU
      libX11
      libXv
      libpulseaudio
      openal
      udev
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk_11_0.frameworks.Cocoa
      darwin.apple_sdk_11_0.frameworks.OpenAL
    ];

  enableParallelBuilding = true;

  makeFlags =
    lib.optionals stdenv.isLinux [ "hiro=gtk3" ]
    ++ lib.optionals stdenv.isDarwin [
      "hiro=cocoa"
      "lto=false"
      "vulkan=false"
    ]
    ++ [
      "local=false"
      "openmp=true"
      "prefix=$(out)"
    ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-mmacosx-version-min=10.14";
  meta = {
    homepage = "https://ares-emu.net";
    description = "Open-source multi-system emulator with a focus on accuracy and preservation";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      Madouura
      AndersonTorres
    ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
}
