#!/bin/bash

# Usage: ./deploy.sh
#
# It infers the target for the deploy by the files under deploy_target_dir (see below).
# For each host you want to deploy to, put a file in there. Eg, for deploting to "alpha", put alpha.json in.
#
# ls ./deploy_targets
# => alpha.json
# ./deploy.sh
# => (deploys to alpha using alpha.json)

basedir=$(dirname $BASH_SOURCE)
basedir=$(pwd)
deploy_target_dir="$basedir/deploy_targets"
# ls $deploy_target_Dir

json_grepper='\.json$'

payload_preparation_dir="$basedir/payloads"

for file in `'ls' -1 $deploy_target_dir | 'grep' -E $json_grepper`
do
  path_to_json="$deploy_target_dir/$file"
  host=`echo $file | 'grep' -E $json_grepper | sed 's/.json$//'`

  # The host key might change when we instantiate a new VM, so
  # we remove (-R) the old host key from known_hosts
  ssh-keygen -R "${host#*@}" 2> /dev/null

  mkdir -p "$payload_preparation_dir/$host"

  cp solo.rb "$payload_preparation_dir/$host/solo.rb"
  cp "deploy_targets/$file" "$payload_preparation_dir/$host/solo.json"
  cp install.sh "$payload_preparation_dir/$host/install.sh"
  cp -R cookbooks "$payload_preparation_dir/$host/"

  cd "$payload_preparation_dir/$host"

  tar cj . | ssh -o 'StrictHostKeyChecking no' "$host" '
  rm -rf ~/chef &&
  mkdir ~/chef &&
  cd ~/chef &&
  tar xj && 
  bash install.sh '$path_to_json

done

rm -r "$payload_preparation_dir"
