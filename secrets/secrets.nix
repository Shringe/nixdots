let
  luminum = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtHOM2G8jkHS54/upxjTWIv/bcjOdPKKgqQLJY5YHfa";
  # diety = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIjDOkukFCIjZ5cpYKqG5QNFt1P0P5oJaYLUglbxENrb";
  shringed = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBomNxAq5H1DKnlCQ0lkmWonsoVno+YAyKwUpSxFBn1e";
in {
  "wireless.age".publicKeys = [ luminum ]; 
  "atuin.age".publicKeys = [ shringed ];
}
