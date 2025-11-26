# Hasktorch Skeleton

Basic MNIST CNN example with Hasktorch based on [Hasktorch](https://github.com/hasktorch/hasktorch-skeleton) template. 


Steps to run it locally. 

1. get into nix 
```sh
nix develop
```
2. Get mnist dataset by running the download-mnist.sh script.
```
./download-mnist.sh
```
3. build 
```sh
cabal build
```
4. run (model will be saved inot static-mnist-cnn.pt file)
```sh 
cabal run
```
