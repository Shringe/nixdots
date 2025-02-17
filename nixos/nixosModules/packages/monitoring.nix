{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nvtopPackages.full
    htop
    btop
  ];
}

