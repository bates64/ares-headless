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

# TODO: this package was derived from nixpkgs, so there might be some inputs/code that isn't needed

let
  extension = if stdenv.isDarwin then "dylib" else "so";
in stdenv.mkDerivation {
  name = "ares_libretro";

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
      darwin.moltenvk
    ];

  enableParallelBuilding = true;

  makeFlags =
    lib.optionals stdenv.isDarwin [
      "lto=false"
    ]
    ++ [
      "local=false"
      "openmp=true"
      "prefix=$(out)"
    ];
  
  installPhase = ''
    mkdir -p $out/lib
    cp libretro/out/ares_libretro.${extension} $out/lib/ares_libretro.${extension}
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-mmacosx-version-min=10.14";

  # Darwin dylibs
  env.SDL2_DYLIB = lib.optionalString stdenv.isDarwin "${SDL2}/lib/libSDL2.dylib";
  env.MOLTENVK_DYLIB = lib.optionals stdenv.isDarwin "${darwin.moltenvk}/lib/libMoltenVK.dylib";

  meta = {
    homepage = "https://ares-emu.net";
    description = "Port of ares to libretro";
    license = lib.licenses.isc;
  };
}
