# Ent docker action

This action uses the `ent` build tool to: build and generate the manifests for and entando bundle project.

## Inputs

## `ent-command`

**Required** The ent command to execute. Default `""`

## Outputs

## `bundle-name`

The name of the bundle, which corresponds to the name of the docker image.

## `bundle-version`

The version of the bundle, which corresponds to the docker image tag.

## `microservices-list`

The list of the microservices. This list corresponds to the list of the docker images that will be generated from the build.

## `microservices-number`

The number of the microservices. This value is used internally to automate the build process of docker images related
to the microservices.

## Example usage

```yaml
uses: entando/catalyst-infra-templates/custom-githun-actions/ent@test-ent
with:
  ent-command: ent bundle pack --org=entando --stdout
```

