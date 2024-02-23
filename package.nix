{
  lib,
  stdenv,
  pkg-config,
  which,
  wrapGAppsHook,
  cpio,
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
  name = "libares";

  src = self;

  nativeBuildInputs = [
    pkg-config
    which
    wrapGAppsHook
    cpio
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
    mkdir -p $out/lib
    cp headless/out/ares.a $out/lib/libares.a

    mkdir -p $out/include
    cd ares
    find . -name '*.hpp' -type f | cpio -pdm $out/include
    cd ..
    find mia -name '*.hpp' -type f | cpio -pdm $out/include
    find nall -name '*.hpp' -type f | cpio -pdm $out/include
    find libco -name '*.hpp' -type f | cpio -pdm $out/include
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
