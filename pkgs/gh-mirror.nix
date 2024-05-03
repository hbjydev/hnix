{ writeShellApplication, git, gh, jq }:
writeShellApplication {
  name = "gh-mirror";
  runtimeInputs = [ git gh jq ];
  text = builtins.readFile ./gh-mirror.sh;
}
