{

inputs = {
  nixpkgs = {
    type = "github";
    owner = "NixOS";
    repo = "nixpkgs";
    ref = "nixpkgs-unstable";
  };
  esobot = {
    type = "github";
    owner = "LyricLy";
    repo = "Esobot";
    ref = "master";
    flake = false;
  };
};

outputs = { self, nixpkgs, esobot }: let
  pkgs = nixpkgs.legacyPackages.x86_64-linux;
  jishaku = pkgs.callPackage ./jishaku.nix {};
  discord-ext-menus = pkgs.callPackage ./discord-ext-menus.nix {};
in {
  packages.x86_64-linux.default = pkgs.python311Packages.buildPythonPackage {
    pname = "esobot";
    version = "0.1.0";
    format = "setuptools";
    disabled = pkgs.python311Packages.pythonOlder "3.11";

    src = esobot;

    propagatedBuildInputs = with pkgs.python311Packages; [
      discordpy
      discord-ext-menus
      unidecode
      pykakasi
      openai
      jishaku
      pillow
      dateparser
      pyahocorasick
    ];

    postUnpack = "cp ${self}/setup.py source/setup.py";

    doCheck = false;
  };
};

}
