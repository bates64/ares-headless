# ares libretro

[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](../LICENSE)

[ares](https://github.com/ares-emulator/ares) as a [libretro](https://www.libretro.com/) core.

# Build

## nix

In the repo root (TODO: move nix stuff to this dir), run

```
nix build
```

which will produce a derivation with `lib/ares_libretro.so` (unix) or `lib/ares_libretro.dylib` (macos).

## Windows

In this directory, run

```
make
```

which will produce `out/ares_libretro.dll`.
