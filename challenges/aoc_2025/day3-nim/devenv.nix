{ pkgs, lib, config, inputs, ... }:

{
  packages = [ pkgs.git ];
  languages.nim.enable = true;
}
