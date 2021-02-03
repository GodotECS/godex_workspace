#!/usr/bin/env bash

set -e

git stash

echo -e "Checkout remotes"
git remote rm godot-ecs || true
git remote add godot-ecs https://github.com/GodotECS/godot
git remote set-url --push godot-ecs https://example.com/
git fetch godot-ecs
git remote rm godotengine || true
git remote add godotengine https://github.com/godotengine/godot
git remote set-url --push godotengine https://example.com/
git fetch godotengine

echo -e "Work"
export ORIGINAL_BRANCH=ecs-scripts-next
export MERGE_REMOTE=godot-ecs
export MERGE_BRANCH=ecs-main
git checkout $ORIGINAL_BRANCH --force
git branch -D $MERGE_BRANCH || true
./thirdparty/git-assembler --assemble --verbose --recreate
git checkout $MERGE_BRANCH -f
export MERGE_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
export MERGE_TAG=$(echo GodotECS.$MERGE_DATE | tr ':' ' ' | tr -d ' \t\n\r')
git tag -a $MERGE_TAG -m "Commited at $MERGE_DATE."
git push $MERGE_REMOTE $MERGE_TAG
git push $MERGE_REMOTE $MERGE_BRANCH -f
git checkout $ORIGINAL_BRANCH --force
git branch -D $MERGE_BRANCH || true