{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.llm.gpt4all;
in
{
  environment.systemPackages = with pkgs; lib.mkIf cfg.cuda [
    gpt4all-cuda
  ];
}
