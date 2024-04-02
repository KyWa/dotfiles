# Kubernetes/OpenShift Things

## Patch
### Delete a key: 
`oc patch resource --merge -p '{"spec":{"object":null}}'`

## InstallPlans
### Find `InstallPlans` needing Approval
`oc get installplan -n NAMESPACE -o jsonpath='{.items[?(@.spec.approved==false)].metadata.name}'`

### Approve `InstallPlan` via `oc patch`
`oc patch installplan $(oc get installplan -n my-project-o=jsonpath='{.items[?(@.spec.approved==false)].metadata.name}') -n NAMESPACE --type merge --patch '{"spec":{"approved":true}}'`
