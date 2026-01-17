{ pkgs, lib, config, inputs, ... }:

{
  languages.scala.enable = true;
  languages.scala.lsp.enable = true;
  languages.scala.mill.enable = true;
}
