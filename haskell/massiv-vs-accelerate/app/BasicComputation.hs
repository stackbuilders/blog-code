module BasicComputation (
    benchBasicComputation,
    BenchArgs(..)
) where

import Criterion.Main (Benchmark, bench, nf, whnf)
import qualified Data.Massiv.Array as M
import qualified Data.Array.Accelerate as A
import qualified Data.Array.Accelerate.LLVM.Native as Native

-- | Arguments for benchmarking basic computation
--   Add more fields as needed for future extensibility
--   For now, only size is used

data BenchArgs = BenchArgs
    { size :: Int
    }

benchBasicComputation :: BenchArgs -> [Benchmark]
benchBasicComputation args =
    let n = size args
        -- Massiv Setup (Parallel Array)
        massivArr = M.makeArray M.Par (M.Sz1 n) id :: M.Array M.P M.Ix1 Int
        -- Accelerate Setup (Expression Graph)
        accelArr = A.fromList (A.Z A.:. n) [0..n-1] :: A.Vector Int
    in
    [ bench "Massiv (CPU Parallel)" $ 
        nf (M.computeAs M.P . M.map (+1)) massivArr
    , bench "Accelerate (LLVM Native)" $ 
        whnf (Native.run . A.map (+1) . A.use) accelArr
    ]
