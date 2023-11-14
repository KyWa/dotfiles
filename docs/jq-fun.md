# BuildConfigs
## Get name of each offending_thing Deployment
```
# Verifies that it has a from field
jq -r '.items[] | select(.spec.strategy | to_entries[].value.from?.name) | .metadata.name')
# Grabs the actual from field
jq -r 'select(.spec.strategy | to_entries[0].value.from.name | contains("offending_thing")) | .metadata.name')
```
# Identify offending_thing image
```
jq -r '.spec.strategy | to_entries[0].value.from.name'
```
# Verify BC type for patch to work
```
jq -r '.spec.strategy | to_entries[0].key'
```

# Deployments/DeploymentConfigs
## Get name of Deployment/DeploymentConfig (and unique) that matches
```
jq -r '.items[] | select(.spec.template.spec.containers[].image | contains("offending_thing"))' | jq -rs 'unique_by(.metadata.name)[] | .metadata.name'
```

## Get name of Deployment/DeploymentConfig (and unique) that matches an either/or check (example is with initContainers and containers, but could be used for checking two things on a single object)
```
jq -r '.items[] | select(.spec.template.spec | select((.containers[]?.image | contains("offending_thing")) or (.initContainers[]?.image | contains("offending_thing"))))' | jq -rs 'unique_by(.metadata.name)[] | .metadata.name'
```

## Get true/false on check of matching string contents
```
jq -r '.spec.template.spec.containers[].image | contains("offending_thing")'
```

## Get name based on selecting path
```
jq -r '.spec.template.spec.containers[] | select(.image == "offending_thing") | .name'
```

## Get just element that matches
```
jq -r '.spec.template.spec.containers[] | select(.image | contains("offending_thing")) .name'
jq -r '.spec.template.spec.containers[] | select(.name == "next-server") .image'
jq -r --arg cont_name bash_env/iterator '.spec.template.spec.containers[] | select(.name == $ARGS.named.cont_name) .image'
```

# ImageStreams
## Get name of ImageStream (and unique) that matches
```
jq -r '.items[] | select(.spec | to_entries[].key | contains("tags"))' | jq -rs 'unique_by(.metadata.name)[] | .metadata.name'
```

## Get name of offending_thing tag
```
jq -r '.spec.tags[] | select(.from.name | contains("offending_thing")) .name'
```

## Get path (name) of image based on ImageStream Tag Name
```
jq -r --arg tag_name bash_env/iterator  '.spec.tags[] | select(.name == $ARGS.named.name) .from.name'
```

# `oc patch` with vars
```
## BuildConfig
oc patch bc NAME -p {\"spec\":{\"strategy\":{\"${BC_TYPE}\":{\"from\":{\"name\":\"${NEW_IMG}\"}}}}}
## Deployment/DeploymentConfig
oc patch deploy NAME -p '{"spec":{"template":{"spec":{"containers":[{"name":"'${CONTAINER_NAME}'","image":"'${NEW_IMG}'"}]}}}}'
## ImageStream
oc patch is NAME -p '{"spec":{"tags":[{"name":"'${TAG_NAME}'","from":{"name":"'${NEW_IMG}'"}}]}}'
```
