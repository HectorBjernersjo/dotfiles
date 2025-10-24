{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        haskellPackages.ghc
        haskellPackages.cabal-install
        haskellPackages.haskell-language-server
    ];
}
