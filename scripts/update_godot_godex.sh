#!/usr/bin/env bash

set -e

git stash

echo -e "Checkout remotes"
git remote rm godot-ecs || true
git remote add godot-ecs https://github.com/GodotECS/godot.git
git remote set-url --push godot-ecs https://example.com/
git fetch godot-ecs
git remote rm godotengine || true
git remote add godotengine https://github.com/godotengine/godot
git remote set-url --push godotengine https://example.com/
git fetch godotengine

echo -e "Work"
git checkout merge-script-master --force
git branch -D "extended-fire" || true
./thirdparty/git-assembler -av
git checkout extended-fire -f
export MERGE_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
export MERGE_TAG=$(echo extended-fire.$MERGE_DATE | tr ':' ' ' | tr -d ' \t\n\r')
git merge -s ours remotes/extended-fire-godot/extended-fire -m "Commited at $MERGE_DATE."
git tag -a $MERGE_TAG -m "Commited at $MERGE_DATE."
git push extended-fire-godot $MERGE_TAG
git push extended-fire-godot extended-fire
git checkout merge-script-master --force
git branch -D extended-fire || true