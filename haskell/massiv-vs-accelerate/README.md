# Massiv vs Accelerate Benchmark Suite

This project benchmarks and compares the performance of [Massiv](https://github.com/lehins/massiv) and [Accelerate](https://github.com/AccelerateHS/accelerate) Haskell array libraries using a variety of operations (map, dot product, stencil/mean blur).

## Project Structure

- `app/Main.hs` — Main benchmarking entry point (Criterion-based)
- `src/` — Library and dependency sources (submodules)
- `Dockerfile` — Containerized build and run environment
- `cabal.project`, `massiv-vs-accelerate.cabal` — Cabal build configuration

## Prerequisites

- [Docker](https://www.docker.com/get-started) (recommended for reproducibility)
- Or: [GHC](https://www.haskell.org/ghc/), [Cabal](https://www.haskell.org/cabal/)

## Quick Start (Docker)

1. **Build the Docker image:**

   ```sh
   docker build -t massiv-vs-accelerate .
   ```

2. **Run a benchmark (e.g., stencil):**

   ```sh
   docker run --rm -it massiv-vs-accelerate bash -c "cabal run massiv-vs-accelerate -- stencil"
   ```

   You can also run other benchmarks:

   - Map: `docker run --rm massiv-vs-accelerate map`
   - Dot Product: `docker run --rm massiv-vs-accelerate dot`
   - Stencil (Massiv only): `docker run --rm massiv-vs-accelerate stencil-massiv`
   - Stencil (Accelerate only): `docker run --rm massiv-vs-accelerate stencil-accel`

   You can pass additional [Criterion](https://hackage.haskell.org/package/criterion) flags after the benchmark type, e.g.:

   ```sh
   docker run --rm massiv-vs-accelerate stencil --output results.html
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
- The Docker image uses the default system GHC and Cabal versions. For custom builds, edit the `Dockerfile`.


