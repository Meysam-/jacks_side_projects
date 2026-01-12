{ pkgs, lib, config, inputs, ... }:

{
  packages = [ pkgs.git ];

  # https://devenv.sh/languages/
  languages.ocaml.enable = true;
}
