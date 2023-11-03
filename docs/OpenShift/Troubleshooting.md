# OCP Troubleshooting


## Stuck ServiceInstance
Primarily an issue with OCP3

`oc edit serviceinstance <name> -n <namespace>`

remove these lines:

```
finalizers:
- kubernetes-incubator/service-catalog
```

## Header fun
  annotations:
    haproxy.router.openshift.io/x-xss-protection: "0"
    haproxy.router.openshift.io/content-security-policy: "default-src 'self'; img-src 'self' base.domain.com"
    haproxy.router.openshift.io/strict-transport-security: "max-age=31536000; includeSubDomains"
    haproxy.router.openshift.io/cache-control: "no-store, no-cache"

## Node Kubeconfig
/etc/kubernetes/static-pod-resources/kube-apiserver-certs/secrets/node-kubeconfigs/

## Podman format
podman build --format v2s1 = for issues with OCP3 Docker pull missing signature key

## PTY Allocation failed OCP4 COREOS ssh - may have been resolved
sudo umount /dev/pts && sudo mount devpts /dev/pts -t devpts

## SMBCLIENT
### Comamnds: https://computerhope.com/unix/smbclien.htm
#### List
smbclient //servername/share -U $USER --password $PASS -c "ls"

#### Get
smbclient //servername/share -U $USER --password $PASS -c "cd folder;get srcfile destfile"

## MachineConfigPool Fun
$ oc patch node $node_name --type merge --patch '{"metadata": {"annotations": {"machineconfiguration.openshift.io/currentConfig": "$new_value"}}}'
$ oc patch node $node_name  --type merge --patch '{"metadata": {"annotations": {"machineconfiguration.openshift.io/desiredConfig": "$new_value"}}}'
$ oc patch node $node_name  --type merge --patch '{"metadata": {"annotations": {"machineconfiguration.openshift.io/reason": ""}}}'
$ oc patch node $node_name  --type merge --patch '{"metadata": {"annotations": {"machineconfiguration.openshift.io/state": "Done"}}}'

## ArgoCD ignoreDifferences for Deployment
  ignoreDifferences:
  - group: apps
    jsonPointers:
    - /spec/template/spec/containers/0/image
    kind: Deployment

## ElasticSearch commands
es_util --query=_cluster/reroute?retry_failed -XPOST
es_util --query=_cluster/health?=pretty

## dockercfg secret
oc create secret generic your-image-reg --from-file=.dockerconfigjson=secret --type=kubernetes.io/dockerconfigjson

## OCP Deployments w/ imagestream trigger
image.openshift.io/triggers: '[{"from":{"kind":"ImageStreamTag","name":"dbam-automation-dsp:final","namespace":"dbam-dsp"},"fieldPath":"spec.template.spec.containers[?(@.name==\"dbam-automation-dsp\")].image",
"pause":"false"}]'

## Annotiations for tolerations
scheduler.alpha.kubernetes.io/defaultTolerations: '[{"key":"node-role.kubernetes.io/infra","operator":"Equal","effect":"NoSchedule","value":""}]'

## etcd restoration
Here are the steps that I took to obtain the manifests from the etcd backup

1.  Decrypt the backup file and extract
a.  openssl aes256 -d -k <key> < <backup_file> | tar -zxvf –
2.  Start an etcd container locally and mount in the backup
a.  docker run -it --rm -v $(pwd):/tmp/etcd:Z --entrypoint=/bin/bash registry.redhat.io/rhel7/etcd:3.2.28
3.  Restore from the snapshot
a.  export ETCDCTL_API=3
b.  etcdctl snapshot restore  <location_of_mounted_snapshot_db> --skip-hash-check
i.  Make sure the output is sent to a location that is also mounted with the host
4.  Exit out of the container
5.  Start a new container that will run a single instance of etcd
a.  docker ru': docker run -d  -v $(pwd):/tmp/etcd:Z  -p 2379:2379 registry.redhat.io/rhel7/etcd:3.2.28 etcd --name=default -advertise-client-urls=http://localhost:2379 -initial-advertise-peer-urls=http://localhost:2380 -listen-client-urls=http://0.0.0.0:2379 -listen-peer-urls=http://localhost:2380 -initial-cluster=node1=http://localhost:2380 --data-dir <location of default.etcd from mounted directory in container>
6.  Extract values from etcd
a.  Values stored in etcd need to be extracted properly
i.  There is an implementation of an etcdhelper script [1] that was originally created by the OpenShift team [2]. The latter has some improvements as well as the dependencies vendored so I built it off the XOM network and use ShareFile to bring in.
1.  Use alpine version as mentioned in the Dockerfile in the repository
2.  Needed to export=GCO_ENABLED=0 so that it would run properly in RHEL/CentOS
b.  Determine which keys to capture
i.  Grab a session inside the running etcd container
ii. export ETCDCTL_API=3
iii.    etcdctl get --prefix --keys-only --command-timeout=1000s / | grep <namespace> > <namespace_keys_file>.txt
1.  There are certainly better ways of doing this, but it worked for this use case
iv. Open the created file and remove the Non-Kubernetes/OpenShift resources along with those that are encrypted
1.  Remove ServiceCatalog, ArgoCD, ProjectInitialize, Secrets/ConfigMaps
c.  Extract the values (Can be run from within the container or on your bastion>
i.  for i in `cat <namespace_keys_file>`; do etcdhelper -endpoint=http://localhost:2379 get $i > $(echo $i | cut -c2- | sed -e 's/\//_/g'); done
ii. All of the extracted values will be created as separate files for review

Lots of fun. Let me know if you have any questions. It certainly could be simplified, but it did the job

### VIm
#### Remove trailing whitespace
:%s/\s\+$//e

## Dead processes - use if nodes aren't listenting to shutdown/reboot commands
top -b -n 1 | awk '{if (NR <=7) print; else if ($8 == "D") {print; count++} } END {print "Total status D: "count}'
