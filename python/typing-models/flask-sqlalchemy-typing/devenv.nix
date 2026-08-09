{ pkgs, lib, config, inputs, ... }:

{
  packages = [
    pkgs.sqlite
  ];

  languages.python = {
    enable = true;
    version = "3.12.0";
    venv = {
      enable = true;
      requirements = "requirements.txt";
    };
  };
}
