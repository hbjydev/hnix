{ stdenv, ... }:
stdenv.mkDerivation {
  name = "haydens-bins";
  version = "unstable";
  src = ./bin;
  installPhase = ''
    mkdir -p $out/bin
    cp * $out/bin
  '';
}
