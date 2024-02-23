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

# TODO(macOS): test, and remove everything related to Cocoa

stdenv.mkDerivation {
  name = "ares-headless";

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
  
  installPhase = ''
    mkdir -p $out
    cp headless/out/ares.a $out/ares.a
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-mmacosx-version-min=10.14";
  meta = {
    homepage = "https://ares-emu.net";
    description = "Open-source multi-system emulator with a focus on accuracy and preservation";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
}
