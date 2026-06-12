# Massiv vs Accelerate Benchmark Suite

This project benchmarks and compares the performance of [Massiv](https://github.com/lehins/massiv) and [Accelerate](https://github.com/AccelerateHS/accelerate) Haskell array libraries using a variety of operations (map, dot product, stencil/mean blur).

## Project Structure

- `app/Main.hs` — Main benchmarking entry point (Criterion-based)
- `app/BasicComputation.hs` — Additional benchmark/support module
- `Dockerfile` — Containerized build and run environment
- `cabal.project`, `massiv-vs-accelerate.cabal` — Cabal build configuration

## Prerequisites

- [Docker](https://www.docker.com/get-started) (recommended for reproducibility)
- Or: [GHC](https://www.haskell.org/ghc/), [Cabal](https://www.haskell.org/cabal/)

## Quick Start (Docker)

The `Dockerfile` provides a reproducible Haskell/LLVM build environment.

Recommended workflow: run an interactive container with the project mounted at `/app`, then execute benchmarks from inside the container.

1. **Build the Docker image:**

   ```sh
   docker build -t massiv-vs-accelerate .
   ```

2. **Start an interactive container:**

   ```sh
   docker run --rm -it \
     --name massiv-vs-accelerate-dev \
       -v "$PWD":/app \
       -w /app \
       massiv-vs-accelerate \
     bash
   ```

3. **Run benchmarks inside the container shell:**

   ```sh
   cabal run massiv-vs-accelerate -- stencil
   ```

   Example with RTS stats:

   ```sh
   cabal run massiv-vs-accelerate -- stencil-massiv +RTS -s
   ```

4. **If the container is already running, attach with `exec`:**

   ```sh
   docker exec -it massiv-vs-accelerate-dev bash
   ```

   Or by container id:

   ```sh
   docker exec -it <container_id> bash
   ```

   You can also run other benchmarks:

   - Map: `cabal run massiv-vs-accelerate -- map`
   - Dot Product: `cabal run massiv-vs-accelerate -- dot`
   - Stencil (Massiv only): `cabal run massiv-vs-accelerate -- stencil-massiv`
   - Stencil (Accelerate only): `cabal run massiv-vs-accelerate -- stencil-accel`

   You can pass additional [Criterion](https://hackage.haskell.org/package/criterion) flags after the benchmark type, e.g.:

   ```sh
   cabal run massiv-vs-accelerate -- stencil --output results.html
   ```

   One-shot alternative (without opening a shell):

   ```sh
   docker run --rm -v "$PWD":/app -w /app massiv-vs-accelerate \
     bash -lc "cabal run massiv-vs-accelerate -- stencil"
   ```

## Manual Setup (Without Docker)

1. **Install dependencies:**

   ```sh
   cabal update
   cabal build --only-dependencies
   ```

2. **Build the project:**

   ```sh
   cabal build
   ```

3. **Run a benchmark:**

   ```sh
   cabal run massiv-vs-accelerate -- [map|dot|stencil|stencil-massiv|stencil-accel] [criterion flags]
   ```

   Example:

   ```sh
   cabal run massiv-vs-accelerate -- stencil
   ```

## Benchmark Types

- `map` — Map (+1) over a large array
- `dot` — Dot product of two large arrays
- `stencil` — 3x3 mean blur (Massiv vs Accelerate)
- `stencil-massiv` — Only Massiv stencil benchmark
- `stencil-accel` — Only Accelerate stencil benchmark

## Notes

- For large benchmarks, you may want to pass RTS flags for memory and GC stats, e.g.:
  ```sh
  cabal run massiv-vs-accelerate -- stencil +RTS -s
  ```
- The Docker image uses `haskell:9.6-slim`, installs LLVM 15, and sets:
   - `LLVM_CONFIG=/usr/bin/llvm-config-15`
   - `ACCELERATE_LLVM_CLANG_PATH=/usr/bin/clang-15`
- `cabal.project` pins Accelerate dependencies to GitHub `master` branches (`accelerate` and `accelerate-llvm` repos).
- If you see `The program 'ghc' ... could not be found`, the command is likely running outside the Docker environment. Confirm you are either:
   - inside the container shell (`root@...:/app#`), or
   - invoking commands through `docker run ... bash -lc "..."`.


