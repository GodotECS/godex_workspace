#!/usr/bin/env bash

set -e

git stash

echo -e "Checkout remotes"
git remote rm SaracenOne || true
git remote add SaracenOne https://github.com/SaracenOne/godot
git remote set-url --push SaracenOne https://example.com/
git fetch SaracenOne
git remote rm lyuma || true
git remote add lyuma https://github.com/lyuma/godot
git remote set-url --push lyuma https://example.com/
git fetch lyuma
git remote rm godotengine || true
git remote add godotengine https://github.com/godotengine/godot
git remote set-url --push godotengine https://example.com/
git fetch godotengine
git remote rm v-sekai-godot || true
git remote add v-sekai-godot https://github.com/V-Sekai/godot
git remote set-url --push v-sekai-godot https://example.com/
git fetch v-sekai-godot
git remote rm "extended-fire-godot" || true
git remote add "extended-fire-godot" git@github.com:godot-extended-libraries/godot-fire.git
# Need
# git remote set-url --push extended-fire-godot https://example.com/
git fetch extended-fire-godot
git remote rm fire || true
git remote add fire git@github.com:fire/godot.git
git remote set-url --push fire https://example.com/
git fetch fire
git remote rm RevoluPowered || true
git remote add RevoluPowered https://github.com/RevoluPowered/godot.git
git remote set-url --push RevoluPowered https://example.com/
git fetch RevoluPowered
git remote rm madmiraal || true
git remote add madmiraal https://github.com/madmiraal/godot.git
git remote set-url --push madmiraal https://example.com/
git fetch madmiraal

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