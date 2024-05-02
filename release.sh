#!/bin/bash

repo=$(gh repo view --json nameWithOwner -q ".nameWithOwner")

# https://michaelcurrin.github.io/auto-tag/installation
sh pr.sh --merge

# Add 3 commits
for i in {1..3}; do
    sh ./pr.sh --merge
done

# Tag the commit 
sh autotag m

newtag=$(git describe --tags --abbrev=0)

git push origin ${newtag}
git push 

release_url=$(curl -s\
  -H "Authorization: token $TOKEN" \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/${repo}/releases \
  -d '{"tag_name": "'"${newtag}"'", "name": "'"${newtag}"'", "generate_release_notes": true}' | jq -r '.html_url')

open -a "/Applications/Google Chrome.app" "$release_url"



