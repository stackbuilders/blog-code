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
       llvm \
       clang \
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
# 1. Create the symlinks so GHC and Accelerate tools exist cleanly in the PATH
# We use -sf to force overwrite existing default paths safely
RUN ln -sf /usr/bin/clang-15 /usr/bin/clang && \
    ln -sf /usr/bin/opt-15 /usr/bin/opt && \
    ln -sf /usr/bin/llc-15 /usr/bin/llc && \
    ln -sf /usr/bin/llvm-config-15 /usr/bin/llvm-config

# 2. Set the environment variables globally for the container
ENV LLVM_CONFIG=/usr/bin/llvm-config
ENV ACCELERATE_LLVM_CLANG_PATH=/usr/bin/clang

# Set up the working directory inside the container
WORKDIR /app

# Update the package list
RUN cabal update

# Copy the cabal configuration first to cache dependencies (optimization step)
COPY *.cabal cabal.project /app/

# Copy the rest of the application source files
COPY . /app

# Pre-compile the project inside the container image
RUN cabal build

# Set the default entry point to execute your compiled benchmark suite
ENTRYPOINT ["cabal", "run", "massiv-vs-accelerate", "--"]