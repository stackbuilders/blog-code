module HasktorchSkeleton
       ( someFunc
       ) where

import Torch
import Control.Monad (when)



groundTruth :: Tensor -> Tensor
groundTruth t = squeezeAll $ matmul t weight + bias
  where
    weight = asTensor ([42.0, 64.0, 96.0] :: [Float])
    bias = full' [1] (3.14 :: Float)

model :: Linear -> Tensor -> Tensor
model state input = squeezeAll $ linear state input



someFunc :: IO ()
someFunc = do
    init <- sample $ LinearSpec{in_features = numFeatures, out_features = 1}
    randGen <- mkGenerator (Device CPU 0) 12345

    (trained, _) <- foldLoop (init, randGen) 2000 $ \(state, randGen) i -> do

       let (input, randGen') = randn' [batchSize, numFeatures] randGen
           (y, y') = (groundTruth input, model state input)
           loss = mseLoss y y'
       when (i `mod` 100 == 0) $ do
            putStrLn $ "Iteration: " ++ show i ++ " | Loss: " ++ show loss
       (state', _) <- runStep state GD loss 5e-3
       pure (state', randGen')
    pure ()
  where
    batchSize = 4
    numFeatures = 3