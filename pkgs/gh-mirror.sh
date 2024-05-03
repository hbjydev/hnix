#!/usr/bin/env bash

org=''${1:-hbjydev}

jq_query=".[] | select(.isPrivate == false) | select (.isFork == false) | {d: .description, r: .name}"

repos=$(gh repo list "$org" --json name,description,isFork,isPrivate --jq "$jq_query" --limit 1000 | jq -s)

cd /var/lib/nginx/html_git || exit
for repo in $(echo "${repos}" | jq -r '.[] | @base64'); do
  _jq() {
    echo "$repo" | base64 --decode | jq -r "$1"
  }

  repo_name=$(_jq .r)
  repo_desc=$(_jq .d)

  echo "$repo_name; $repo_desc"

  echo "Cloning repo $repo_name"
  gh repo clone "$org/$repo_name" "$repo_name" -- -q 2>/dev/null || (
    cd "$repo_name"
    # Handle case where local checkout is on a non-main/master branch
    # - ignore checkout errors because some repos may have zero commits, 
    # so no main or master
    git checkout -q main 2>/dev/null || true
    git checkout -q master 2>/dev/null || true
    git pull -q
  )
  echo "$repo_desc" > "$repo_name/.git/description"
done
