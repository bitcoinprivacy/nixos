with import <nixpkgs> {};
{
  javaEnv = stdenv.mkDerivation {
    name = "java-env";
    JAVA_HOME = "${openjdk}/lib/openjdk";
    shellHook = ''

    export PS1="bge-prompt > " '';

    buildInputs = [
      openjdk
      ];
                                                       };
                                                       } 
