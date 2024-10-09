{
  users = {
    groups = {
      nixdots = {};
    };
    users = {
      shringe = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "audio" "nixdots" ];
        initialPassword = "123";
      };
    };
  };
}
