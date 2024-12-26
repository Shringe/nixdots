{
  imports = [
    ./shringe.nix
    ./shringed.nix
  ];


  users = {
    mutableUsers = false;

    groups = {
      nixdots = {};
    };

    users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4ApgoaedJkfYAoaNsK1Zx7EikM8mIwkUNpGnn/wU1W"
    ];
  };
}
