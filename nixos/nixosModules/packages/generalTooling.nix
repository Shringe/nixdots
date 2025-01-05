{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ranger
    yt-dlp
    ffmpeg
    unzip
    unrar
  ];
}
