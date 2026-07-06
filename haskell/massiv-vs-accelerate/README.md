# Massiv vs Accelerate Benchmark Suite

This project benchmarks and compares the performance of [Massiv](https://github.com/lehins/massiv) and [Accelerate](https://github.com/AccelerateHS/accelerate) Haskell array libraries using a variety of operations (map, dot product, stencil/mean blur).

## Project Structure

- `app/Main.hs` — Main benchmarking entry point (Criterion-based)
- `src/` — Library and dependency sources (submodules)
- `Dockerfile` — Containerized build and run environment matching target LLVM pipelines
- `cabal.project`, `massiv-vs-accelerate.cabal` — Cabal build configuration

## Prerequisites

- [Docker](https://www.docker.com/get-started) (highly recommended for ARM64 toolchain compatibility and reproducibility)
- Or: [GHC 9.6+](https://www.haskell.org/ghc/), [Cabal](https://www.haskell.org/cabal/), and **LLVM 15** installed with `clang`/`opt`/`llc` binaries mapped to your system path.

## Quick Start (Docker)

1. **Build the containerized environment:**

```sh
   docker build -t massiv-vs-accelerate .
```

2. **Run isolated library benchmarks:**
Pass the specific operation name directly to the container runner to evaluate both libraries back-to-back:

Massiv Stencil Only:
```bash
docker run --rm massiv-vs-accelerate stencil-massiv
```
Accelerate Stencil Only:

```bash
docker run --rm massiv-vs-accelerate stencil-accel
```

3. **Passing Criterion and GHC Runtime (+RTS) Flags:**

Because the container features an automated entrypoint wrapper, you can append reporting flags or memory profiling switches straight to your commands:

```bash
# Export an interactive HTML chart to your current host directory
docker run --rm -v $(pwd):/app/out massiv-vs-accelerate stencil --output out/results.html

# Inspect memory allocation and GC productivity profiles (+RTS -s)
docker run --rm massiv-vs-accelerate stencil-massiv +RTS -s

```

4. **Manual Setup (Without Docker)**
Configure dependencies:

Ensure llvm-15 toolchains are [globally](https://www.acceleratehs.org/get-started.html) exposed on your machine.

1. Install llvm dependencies

brew install llvm@15 libffi pkg-config

2. Expose the New Binaries to Your Local Terminal
```bash
# 1. Force your active terminal context to prioritize LLVM 15
export PATH="/opt/homebrew/opt/llvm@15/bin:$PATH"

# 2. Bind development header search flags 
export LDFLAGS="-L/opt/homebrew/opt/llvm@15/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm@15/include"

# 3. Explicitly link tool locations for the GHC and Accelerate compiler pipelines
export LLVM_CONFIG="/opt/homebrew/opt/llvm@15/bin/llvm-config"
export ACCELERATE_LLVM_CLANG_PATH="/opt/homebrew/opt/llvm@15/bin/clang"
```

Trigger the native build
```
cabal clean && cabal build
```
Run a benchmark:

```Bash
cabal run massiv-vs-accelerate -- [map|dot|stencil|stencil-massiv|stencil-accel] [criterion flags]
```
Example:

```Bash
cabal run massiv-vs-accelerate -- stencil
```
5. **Benchmark Types**
- map — Map (+1) over a large array

- dot — Dot product of two large arrays

- stencil — 3x3 mean blur matrix operations comparison

- stencil-massiv — Isolated Massiv stencil loop

- stencil-accel — Isolated Accelerate LLVM backend stencil