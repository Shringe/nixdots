{
  imports = [
    ./mangohud
  ];

  # Look for desktop files of system flatpaks
  xdg.systemDirs.data = [
    "/var/lib/flatpak/exports/share"
  ];
}
