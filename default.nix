{ lib, runCommand, hugo }:

runCommand "holyjit-org" {
   src = lib.cleanSource ./.;
   buildInputs = [ hugo ];
} ''
  hugo --log --debug --noChmod -s $src -d $out
''
