#!/usr/bin/env bash

# Run ent commands
$@

# Get the bundle name from the entando.json file with jq
bundle_name=$(jq -r '.name' entando.json)
echo "bundle-name=$bundle_name" >> $GITHUB_OUTPUT

# Get the bundle version from the entando.json file with jq
bundle_version=$(jq -r '.version' entando.json)
echo "bundle-version=$bundle_version" >> $GITHUB_OUTPUT

# Get the list of microservices to build
microservices_list=$(jq -r '.microservices[] | .name' entando.json | tr -d '\n')
echo "microservices-list=$microservices_list" >> $GITHUB_OUTPUT

# Get the number of microservices to build
microservices_number=$(jq '.microservices | length' entando.json)
echo "microservices-number=$microservices_number" >> $GITHUB_OUTPUT

