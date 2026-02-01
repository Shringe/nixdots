# https://unix.stackexchange.com/questions/648666/rename-devices-in-pipewire
{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.music.rename_devices;
  mkRename = nodeName: newDescription: ''
    {
        matches = [
            { node.name = "${nodeName}" }
        ],
        actions = {
            update-props = {
                node.description = "${newDescription}"
            }
        }
    }
  '';
in
{
  options.homeManagerModules.desktop.music.rename_devices = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "renaming of audio devices to be more distinguishable";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."wireplumber/wireplumber.conf.d/99-renames.conf".text = ''
      monitor.alsa.rules = [
          ${mkRename "alsa_input.pci-0000_0c_00.6.analog-stereo" "Headset Microphone"}
          ${mkRename "alsa_output.pci-0000_0c_00.6.analog-stereo" "Headset Speakers"}
          ${mkRename "alsa_output.pci-0000_01_00.1.hdmi-stereo" "Monitor Speakers"}
      ]
    '';
  };
}
