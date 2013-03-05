## Background

A simple chef-solo deploy package. 

Original method and idea comes from the following blogpost from 
http://opinionatedprogrammer.com/2011/06/chef-solo-tutorial-managing-a-single-server-with-chef/

Adapted by jcwilk at https://github.com/jcwilk/chef_solo_deploy

Further tweaked by felixandersen at https://github.com/felixandersen/chef_solo_deploy

## Usage

Place a config for each host you want to configure in deploy_targets/. If your
host is reachable at example.com, name the file example.com.json. See 
example_host.json for an example config.

Place any cookbooks that your configs use in cookbooks/

Run the script, ./deploy.sh, to run chef-solo with the specified recipes on each host.
