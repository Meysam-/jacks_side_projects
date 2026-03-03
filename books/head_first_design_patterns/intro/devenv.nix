{ pkgs, lib, config, inputs, ... }:

{
  packages = [ pkgs.git ];

  # https://devenv.sh/languages/
  languages.kotlin.enable = true;
}
