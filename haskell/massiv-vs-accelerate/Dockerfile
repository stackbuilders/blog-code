# We use GHC 9.6 as our base
FROM haskell:9.6-slim

# Install wget and gnupg to add the LLVM repository
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    lsb-release \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Use the official LLVM setup script to install LLVM 15
# This handles the repository addition for any Debian version (Buster/Bullseye/Bookworm)
RUN wget https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \
    && ./llvm.sh 15 \
    && apt-get install -y \
       llvm-15-dev \
       libffi-dev \
       libedit-dev \
       libfftw3-dev \
       pkg-config \
       zlib1g-dev \
       g++ \
       make \
    && rm -rf /var/lib/apt/lists/*

# THE FIXES:
# 1. Create the symlink so 'clang' exists in the PATH
RUN ln -s /usr/bin/clang-15 /usr/bin/clang

# 2. Set the environment variables globally for the container
ENV LLVM_CONFIG=/usr/bin/llvm-config-15
ENV ACCELERATE_LLVM_CLANG_PATH=/usr/bin/clang-15

WORKDIR /app
RUN cabal update