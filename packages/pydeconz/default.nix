{ python37, python37Packages, pkgs  }:

#with import <nixpkgs> {};

python37.pkgs.buildPythonPackage rec {
  pname = "pydeconz";
  version = "47";

  src = python37.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "1d8drgy712sxxvisdaz53jgyiiidbhvnbrsvgci6jh9b6s6189wb";
  };

  buildInputs = [ pkgs.unstable.python37Packages.aiohttp ];
  doCheck = false;
}
