#!/usr/bin/env bash

# 
# This script creates /nixdots under the group nixdots with g+rw permissions, then copies the current working directory into /nixdots 
#

bootstrap_dir="/nixdots"
group_name="nixdots"

# Fancy exec
# Just prints command before executing
function fexec {
  echo "> $@"
  $@
}

echo "Creating directory"
fexec mkdir "$bootstrap_dir"
fexec cp -r . "$bootstrap_dir"

echo "Setting permisions"
fexec chown -R :"$group_name" "$bootstrap_dir"
fexec chmod -R g+rw "$bootstrap_dir"

echo "Finished."
