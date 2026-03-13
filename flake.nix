{
  description = "Nix flake for the claude-statusline CLI tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Use your preferred Nixpkgs branch
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.callPackage ./pkgs { };
    packages.aarch64-linux.default = nixpkgs.legacyPackages.aarch64-linux.callPackage ./pkgs { };
    packages.x86_64-darwin.default = nixpkgs.legacyPackages.x86_64-darwin.callPackage ./pkgs { }; # Added for Intel Macs
    packages.aarch64-darwin.default = nixpkgs.legacyPackages.aarch64-darwin.callPackage ./pkgs { }; # Added for Apple Silicon Macs
  };
}
