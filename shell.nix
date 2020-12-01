{ pkgs ? import ./nix {}
}:

with pkgs;

stdenv.mkDerivation rec {
  name = "env";
  src = ./.;
  env = buildEnv { name = name; paths = buildInputs; };
  builder = builtins.toFile "builder.pl" ''
    source $stdenv/setup; ln -s $env $out
  '';
  buildInputs = [
    (texlive.combine {
      inherit (texlive)
        scheme-basic
        appendixnumberbeamer
        beamer
        beamertheme-metropolis
        booktabs
        catchfile
        ccicons
        cm-super
        ec
        enumitem
        epstopdf
        etoolbox
        fancyvrb
        fira
        float
        fontaxes
        framed
        fvextra
        graphics
        hyperref
        ifplatform
        latex
        latexmk
        lineno
        microtype
        minted
        ms
        mweights
        fontawesome
        pgf
        pgfopts
        pgfplots
        preview
        translator
        upquote
        xcolor
        xkeyval
        xstring;
    })
    curl
    ghostscript
    gnumake
    pythonPackages.pygments
    unzip
    which
  ];
}
