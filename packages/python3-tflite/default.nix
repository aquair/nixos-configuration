{ stdenv, lib, python37, fetchurl, python37Packages  }:

#with import <nixpkgs> {};

python37.pkgs.buildPythonPackage rec {
  pname = "tflite";
  version = "2.2.0";
  format = "wheel";

  disabled = !python37.pkgs.isPy3k;

  src = fetchurl {
    url = "https://dl.google.com/coral/python/tflite_runtime-2.1.0.post1-cp37-cp37m-linux_x86_64.whl";
    sha256 = "17g13d42dy4xxchryc67spqj7i14ilzclvar6g8b7ypz50adkb9d";
  };

  buildInputs = [ python37Packages.numpy python37Packages.pip ];
  doCheck = false;

  preConfigure = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${stdenv.cc.cc.lib}/lib/libstdc++.so.6"
  '';


  preShellHook = ''
      mkdir -p $out/lib/
      ln -s ${stdenv.cc.cc.lib}/lib/libstdc++.so.6 $out/lib/
    '';

}
