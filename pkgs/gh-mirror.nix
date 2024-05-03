{ writeShellApplication, git, gh }:
writeShellApplication {
  name = "gh-mirror";
  runtimeInputs = [ git gh ];
  text = builtins.readFile ./gh-mirror.sh;
}
