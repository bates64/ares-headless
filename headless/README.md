# ares-headless

[![License: ISC](https://img.shields.io/badge/License-ISC-blue.svg)](../LICENSE)

This is a fork of [ares](https://github.com/ares-emulator/ares) that produces an LLVM archive file for use within other projects.

# Build

In the repo root, run

```
nix build
```

which will produce `result/ares.a`.

# Changes

[The makefile](GNUMakefile) is a copy of [desktop-ui's makefile](../desktop-ui/GNUmakefile) with the following changes:

- Produce an archive rather than an executable
- Disable LTO
- No `ruby` or `hiro` (GUI code)
- N64 core only (temporary)
