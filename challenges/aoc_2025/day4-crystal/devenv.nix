{ pkgs, lib, config, inputs, ... }:

{
  packages = [ pkgs.git ];
  languages.crystal.enable = true;
}
