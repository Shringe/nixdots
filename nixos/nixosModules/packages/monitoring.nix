{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nvtop
    htop
    btop
  ];
}

