{ runCommand, hugo }:

runCommand "holyjit-org" {
   buildInputs = [ hugo ];
} ''
  echo Done.
''
