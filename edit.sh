#!/usr/bin/env bash

flake_dir=$(realpath $(dirname "$0"))
path_to_edit="$flake_dir/$1"
editor=$EDITOR

function editPath {
  $editor $path_to_edit
}

function nixRebuildSwitch {
  local sleep_seconds=2

  echo "Press <C-c> within $sleep_seconds seconds to cancel NixOS rebuild."
  sleep $sleep_seconds

  sudo nixos-rebuild switch --flake "$flake_dir"
}

function gitCommit {
  git commit -m "Auto commit."
}

editPath
nixRebuildSwitch
gitCommit
