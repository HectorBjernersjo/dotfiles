{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs;[
        nodePackages.typescript
        nodePackages.typescript-language-server
  ];
}
