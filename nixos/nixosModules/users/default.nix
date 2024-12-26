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
  };
}
