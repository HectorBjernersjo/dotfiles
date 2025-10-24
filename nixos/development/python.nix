{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (python3.withPackages (ps: with ps; [ numpy psutil humanize matplotlib ]))
  ];
}
