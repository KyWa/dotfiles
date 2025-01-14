# Kubernetes/OpenShift Things

## Patch
### Delete a key: 
`oc patch resource --type=merge -p '{"spec":{"object":null}}'`

## InstallPlans
### Find `InstallPlans` needing Approval
`oc get installplan -n NAMESPACE -o jsonpath='{.items[?(@.spec.approved==false)].metadata.name}'`

### Approve `InstallPlan` via `oc patch`
`oc patch installplan $(oc get installplan -n my-project-o=jsonpath='{.items[?(@.spec.approved==false)].metadata.name}') -n NAMESPACE --type merge --patch '{"spec":{"approved":true}}'`

## Misc Handy Commands
### Get Pods that aren't running and sort by age
`oc get po --field-selector=status.phase!=Running --sort-by=.metadata.creationTimestamp`

## AlertManager
### Get Firing Alerts in openshift-monitoring
`oc -n openshift-monitoring exec -c prometheus prometheus-k8s-0 -- curl -s   'http://localhost:9090/api/v1/alerts'`
`oc get prometheusrules -A -o jsonpath='{.items[*].spec.groups[].rules[]}'`

### Get Firing Alerts in openshift-user-workload-monitoring
`oc exec -c alertmanager alertmanager-user-workload-0 -- curl -s 'http://localhost:9093/api/v1/alerts'`

## CloudCredential Operator Secret Sync
A `CredentialsRequest` is needs to be created which the `openshift-cloud-credential` Operator watches to then sync it to another namespace as provided in the spec:
```yaml
apiVersion: cloudcredential.openshift.io/v1
kind: CredentialsRequest
metadata:
  name: some-credential-request
  namespace: openshift-cloud-credential-operator
spec:
  providerSpec:
    apiVersion: cloudcredential.openshift.io/v1
    kind: VSphereProviderSpec # Or whichever the platform you are running on is
  secretRef:
    name: some-secret
    namespace: some-namespace
```

Add the following `annotation` to a `Secret` you wish to sync from the `kube-system` namespace:
`cloudcredential.openshift.io/mode: passthrough`

The following metadata items get added to the "synced" `Secret`:
```
## Label
cloudcredential.openshift.io/credentials-request: 'true'
## Annotation
cloudcredential.openshift.io/credentials-request: openshift-cloud-credential-operator/openshift-machine-api-vsphere
```
