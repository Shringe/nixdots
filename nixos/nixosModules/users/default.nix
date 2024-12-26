{
  imports = [
    ./shringe
    ./shringed
  ];


  users = {
    mutableUsers = false;

    groups = {
      nixdots = {};
    };
  };
}
