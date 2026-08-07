{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    gnumake
    pre-commit
    hadolint
  ];

  shellHook = ''
    make install-hooks
  '';
}
