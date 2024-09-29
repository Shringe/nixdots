{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (stdenv.mkDerivation {
      pname = "myscript";
      version = "1.0";
      src = null;
      installPhase = ''
        mkdir -p $out/bin
	cat > $out/bin/myscript <<'EOF'
	#!/usr/bin/env/bash
	echo "TestSCRIPT"
	EOF
	chmod +x $out/bin/myscript
      '';
    })
  ];
}
