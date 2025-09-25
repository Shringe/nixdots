{ pkgs, ... }:
let
  crazyUsbSleepHook = pkgs.writeShellApplication {
    name = "crazyUsbSleepHook";
    runtimeInputs = with pkgs; [
      coreutils
    ];

    text = ''
      case $1 in
        pre) echo "0000:00:14.0" | tee /sys/bus/pci/drivers/xhci_hcd/unbind ;;
        post) echo "0000:00:14.0" | tee /sys/bus/pci/drivers/xhci_hcd/bind ;;
      esac
    '';
  };
in
{
  # The system gets a core pegged at %100 by kworker if the crazy usb is trying to suspend, and pipewire is active
  boot.kernelParams = [
    "usbcore.autosuspend=-1"
  ];

  # The system cant sleep if the crazy usb if awake
  environment.etc."systemd/system-sleep/crazyUsb" = {
    source = "${crazyUsbSleepHook}/bin/crazyUsbSleepHook";
    # mode = "0755";
  };
}
