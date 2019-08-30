# OpenShift Registry

The OpenShift installer configures a default persistent registry, which uses NFS shares as defined by the set of `openshift_hosted_registry_storage_*` variables in the inventory file. In a production environment, Red Hat recommends using an external server (not the OpenShift cluster) for storage.

In the below example inventory file, the `[nfs]` group contains the list of NFS servers. The server is used in conjuctino with the set of `openshift_hosted_registry_storage*` variables to configure the NFS server.

```
[OSEv3:vars]
openshift_hosted_registry_storage_kind=nfs
openshift_hosted_registry_storage_access_modes=['ReadWriteMany']
openshift_hosted_registry_storage_nfs_directory=/exports
openshift_hosted_registry_storage_nfs_options='*(rw,root_squash)'
openshift_hosted_registry_storage_volume_name=registry
openshift_hosted_registry_storage_volume_size=40Gi ...output omitted...

[nfs]
services.lab.example.com
```

After the installation and configuration of the storage for the persistent registry, OpenShift creates a persistent volume in the `openshift` project named `registry-volume`. It has a capacity of 40GB and a policy of `Retain`, as set by the definition.
