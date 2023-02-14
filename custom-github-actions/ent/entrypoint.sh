#!/usr/bin/env bash

# Run ent commands
$@

# Get the bundle name from the entando.json file with jq
bundle_name=$(jq -r '.name' entando.json)
echo "bundle-name=$bundle_name" >> $GITHUB_OUTPUT

# Get the bundle version from the entando.json file with jq
bundle_version=$(jq -r '.version' entando.json)
echo "bundle-version=$bundle_version" >> $GITHUB_OUTPUT

# Get the number of microservices to build
microservices_number=$(jq '.microservices | length' entando.json)
echo "microservices-number=$microservices_number" >> $GITHUB_OUTPUT

# Get the list of microservices to build
microservices_list=""
if [ "${microservices_number}" -gt 1 ]; then
  microservices_list=$(jq -r '.microservices[] | .name' entando.json | tr '\n' ' ')
  else
    microservices_list=$(jq -r '.microservices[] | .name' entando.json | tr -d '\n')
fi
echo "microservices-list=$microservices_list" >> $GITHUB_OUTPUT

# Get the the version of the microservice to build from the pom.xml.
# The version is used as tag for the docker image.
if [ "${microservices_number}" -gt 1 ]; then
  for ms in ${microservices_list} ; do
    microservice_version="$(mvn -f microservices/${ms}/pom.xml help:evaluate -Dexpression=project.version -q -DforceStdout)"
    # for each microservice is being generated a file which is named with the microservice name and contains its version in it
    printf "%s" "${microservice_version}" > ms-"${ms}"-version ;
    done
else
  microservices_list_local="$(jq -r '.microservices[] | .name' entando.json | tr -d '\n')"
  microservice_version="$(mvn -f microservices/${microservices_list_local}/pom.xml help:evaluate -Dexpression=project.version -q -DforceStdout)"
  printf "%s" "${microservice_version}" > microserviceVersion
fi

