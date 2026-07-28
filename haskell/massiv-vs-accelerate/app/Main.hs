module Main where

import Criterion.Main
import System.Environment (getArgs, withArgs)
import qualified Data.Massiv.Array as M
import qualified Data.Array.Accelerate as A
import qualified Data.Array.Accelerate.LLVM.Native as Native


-- | 3x3 mean (average) stencil for 2D arrays in Massiv.
--
-- This stencil computes the average of a 3x3 neighborhood around each element.
-- It is used for mean blurring (smoothing) operations on 2D arrays.
--
-- The stencil uses zero-padding (see usage with 'M.Fill 0.0') at the boundaries.
--
-- Example usage:
--
-- > M.mapStencil (M.Fill 0.0) massivMeanStencil arr
--
-- Where 'arr' is a 2D Massiv array of type 'M.Array M.P M.Ix2 Double'.
massivMeanStencil :: M.Stencil M.Ix2 Double Double
massivMeanStencil = M.makeStencil (M.Sz2 3 3) (1 M.:. 1) $ \get ->
  (  get (-1 M.:. -1) + get (-1 M.:. 0) + get (-1 M.:. 1)
   + get ( 0 M.:. -1) + get ( 0 M.:. 0) + get ( 0 M.:. 1)
   + get ( 1 M.:. -1) + get ( 1 M.:. 0)    + get ( 1 M.:. 1)
  ) / 9

-- | 3x3 mean (average) stencil function for Accelerate.
--
-- This function computes the average of a 3x3 neighborhood for use with Accelerate's 'stencil' operation.
-- It is typically used for mean blurring (smoothing) on 2D arrays.
--
-- The input is a 3x3 tuple of values (top-left, top-center, top-right, etc.).
--
-- Example usage:
--
-- > A.stencil accelMeanStencil A.clamp arr
--
-- Where 'arr' is an Accelerate 2D array of type 'A.Array A.DIM2 Double'.
accelMeanStencil :: A.Stencil3x3 Double -> A.Exp Double
accelMeanStencil ((tl, tc, tr),
                  (ml, mc, mr),
                  (bl, bc, br)) = (tl + tc + tr + ml + mc + mr + bl + bc + br) / 9

size :: Int
size = 10000000

main :: IO ()
main = do
    allArgs <- getArgs
    case allArgs of
        (testType:rest) -> 
            -- 'withArgs' replaces the global command-line arguments 
            -- for the duration of the provided IO action.
            withArgs rest $ case testType of
                "map" -> runMapBenchmarks
                "dot" -> runDotBenchmarks
                "stencil-massiv" -> runMassivOnly -- Run only the Massiv stencil benchmark with +RTS -s flag
                "stencil-accel"  -> runAccelOnly -- Run only the Accelerate stencil benchmark with +RTS -s flag
                "stencil" -> runStencilBenchmarks
                _     -> putStrLn "Unknown test type. Use 'map', 'dot', or 'stencil'."
        _ -> putStrLn "Usage: cabal run massiv-vs-accelerate -- [map|dot|stencil] [criterion flags]"

runMapBenchmarks :: IO ()
runMapBenchmarks = do
    let massivArr = M.makeArray M.Par (M.Sz1 size) id :: M.Array M.P M.Ix1 Int
    let accelArr  = A.fromList (A.Z A.:. size) [0..size-1] :: A.Vector Int
    
    defaultMain [
        bgroup "Map (+1)" [
            bench "Massiv (CPU Parallel)" $ 
                nf (M.computeAs M.P . M.map (+1)) massivArr,
            bench "Accelerate (LLVM Native)" $ 
                whnf (Native.run . A.map (+1) . A.use) accelArr
        ]
      ]

runDotBenchmarks :: IO ()
runDotBenchmarks = do
    let m1 = M.makeArray M.Par (M.Sz1 size) (const 2) :: M.Array M.P M.Ix1 Int
    let m2 = M.makeArray M.Par (M.Sz1 size) (const 3) :: M.Array M.P M.Ix1 Int
    
    let a1 = A.fromList (A.Z A.:. size) (replicate size 2) :: A.Vector Int
    let a2 = A.fromList (A.Z A.:. size) (replicate size 3) :: A.Vector Int

    defaultMain [
        bgroup "Dot Product" [
            bench "Massiv (CPU Parallel)" $ 
                nf (\(x, y) -> M.sum (M.zipWith (*) x y)) (m1, m2),
            bench "Accelerate (LLVM Native)" $ 
                whnf (\(x, y) -> Native.run (A.fold (+) 0 (A.zipWith (*) (A.use x) (A.use y)))) (a1, a2)
        ]
      ]

runStencilBenchmarks :: IO ()
runStencilBenchmarks = do
    let side = 3162
    let sz = M.Sz2 side side
    
    -- Massiv Setup
    let mArr = M.makeArray M.Par sz (\(i M.:. j) -> fromIntegral (i + j)) :: M.Array M.P M.Ix2 Double
    
    -- Accelerate Setup
    let aArr = A.fromList (A.Z A.:. side A.:. side) [0..(fromIntegral (side*side - 1))] :: A.Array A.DIM2 Double

    defaultMain [
        bgroup "3x3 Mean Blur" [
            bench "Massiv (Stencil)" $ 
                nf (M.computeAs M.P . M.mapStencil (M.Fill 0.0) massivMeanStencil) mArr,
            
            bench "Accelerate (LLVM Stencil)" $ 
                nf (Native.run . A.stencil accelMeanStencil A.clamp . A.use) aArr
        ]
      ]

runMassivOnly :: IO ()
runMassivOnly = do
    let side = 3162
    let sz = M.Sz2 side side
    let mArr = M.makeArray M.Par sz (\(i M.:. j) -> fromIntegral (i + j)) :: M.Array M.P M.Ix2 Double
    defaultMain [ bench "Massiv (Isolated)" $ nf (M.computeAs M.P . M.mapStencil (M.Fill 0.0) massivMeanStencil) mArr ]

runAccelOnly :: IO ()
runAccelOnly = do
    let side = 3162
    let aArr = A.fromList (A.Z A.:. side A.:. side) [0..(fromIntegral (side*side - 1))] :: A.Array A.DIM2 Double
    defaultMain [ bench "Accelerate (Isolated)" $ whnf (Native.run . A.stencil accelMeanStencil A.clamp . A.use) aArr ]

