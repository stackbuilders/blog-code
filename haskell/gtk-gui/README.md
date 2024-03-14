# Creating a GUI application in Haskell with GTK+

## Description

This project serves as a companion codebase for Stack Builder's blog post ["Creating a GUI application in Haskell."](https://www.stackbuilders.com/blog/gui-application/)

## Requirements

- Stack 2.11.1
- Cabal 3.10.2.1
- GHC 9.4.7

## Installation

For installation instructions of C libraries required by Gtk2Hs and haskell-gi, please refer to the [Gtk2Hs Github Repository](https://github.com/gtk2hs/gtk2hs?tab=readme-ov-file#installing-c-libraries). The installation process may vary depending on your operating system, so make sure to follow the instructions specific to your platform.

## Building and Running the Project

1. **Clone the Repository**: Clone this repository to your local machine and navigate to the project directory.

   ```bash
   git clone https://github.com/stackbuilders/blog-code.git
   cd haskell/gtk-gui/
   ```

2. **Install the necessary tools for gtk2hs**: You need to install some tools to build GTK+ bindings. Run the following commands:

   ```bash
   stack install alex happy
   stack install haskell-gi
   stack install gtk2hs-buildtools
   stack install
   ```

3. **Build the Project**: Use Stack to build the project.

   ```bash
   stack build
   ```

4. **Run the Project**: Run the project with the following command:

   ```bash
    stack exec gtk-gui-exe
   ```
