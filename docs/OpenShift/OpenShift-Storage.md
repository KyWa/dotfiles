# OpenShift Storage

In OpenShift to allow storage from the host to a container/pod you must modify the SELinux configuration via: `semanage fcontext -a -t container_file_t '/path/to/data(/.*)?'`. Don't forget to apply them via `restorecon -Rv /path/to/data`.

`PersistentVolumes` can be seen via an `oc get pv` call. To create a `PersistentVolume` you need a basic config to apply via `oc create -f file.yml`. Example of a `PersistentVolumeClaime` below:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myapp
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

Then you can update your deployment/template with the volumes section as outlined below:

```yaml
apiVersion: "v1"
kind: "Pod"
metadata:
  name: "myapp"
  labels:
    name: "myapp"
spec:
  containers:
    - name: "myapp"
      image: openshift/myapp
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/var/www/html"
          name: "pvol" 
  volumes:
    - name: "pvol" 
      persistentVolumeClaim:
        claimName: "myapp"
```

### OpenShift-Supported Plug-ins for Persistent Storage

Volumes are mounted file systems that are availabler to pods and their containers and can be backed by a number of local or network-attached storage endpoints. OpenShift uses plug-ins to support the following for persistent storage:

* NFS
* GlusterFS
* OpenStack Cinder
* Ceph RBD
* AWS Elastic Block Store (EBS)
* GCE Persistent Disk
* iSCSI
* Fibre Channel
* Azure Disk and Azure File
* FlexVolume (allows for the extension of storage back-ends that do not have a built-in plug-in)
* VMWare vSphere
* Dynamic Provisioning and Creating Storage Classes
* Volume Security
* Selector-Label Volume Binding

### Persistent Volume Access Modes

A `pv` can be mounted on a host in any way supported by the resource provider. Providers have different capabilities and each persistent volume's access modes are set to the specific modes supported by that particular volume. For example, NFS can support multiple read/write clients, but a specific NFS `pv` might be exported on the server as read-only. Each `pv` receives its own set of access modes describing that specific persistent volume's capabilites. 

#### Access Mode Table
| Access Mode     | CLI Abberviation | Description                                               |   |
| `ReadWriteOnce` | `RWO`            | The volume can be mounted as read/write by a single node. |   |
| `ReadOnlyMany`  | `ROX`            | The volume can be mounted read-only by many nodes.        |   |
| `ReadWriteMany` | `RWX`            | The volume can be mounted as read/write by many nodes.    |   |

`PV` claims are matched to volumes with similar access modes. The only two matching criteria are access modes and size. A claim's access mdoes represent a request. Therefore, users can be granted greater, but never lesser access. For example, if a claim requests `RWO`, but the only volume available was an NFS PV (`RWO`+`ROX`+`RWX`), the claim would match NFS because it supports `RWO`.

All volumes with the same modes are grouped, and then sorted by size (smallest to largest). The service on the master responsible for binding the `pv` to the `pvc` receives the group with matching modes and iterates over each (in size order) until one size matches, then binds the `pv` to the `pvc`.

### Using NFS for Persistent Volumes

OpenShift runs containers using randim `UID`s, therefore mapping Linux users from Openshift nodes to users on the NFS server does not work as intended. NFS shares used as OpenShift PVs must be configured as follows:

* Owned by the `nfsnobody` user and group
* Have `rwx------` perms (`0700`)
* Exported using the `all_squash` option

Example `/etc/exports` entry: `/var/export/vol *(rw,async,all_squash)`

Other NFS export options, ex.. `sync` and `async`, do not matter to OpenShift. OpenShift works if either option is used. In high-latency environments, adding the `async` option facilitates faster write oeprations to the NFS share (for example, image pushes to the registry). Using the `async` option is faster because the NFS server replies to the client as soon as the request is processed without waiting for the data to be written to disk. When using the `sync` option the behavior is the opposite. The NFS server only responds once all the data has been written to disk for that request.

Default SELinux policies do not allow containers to access NFS shares. The policy must be changed in every OpenShift instance node by setting the `virt_use_nfs` and `virt_sandbox_use_nfs` variables to `true`. These flags are automatically configured by the OpenShift installer. `setsebool -P virt_use_nfs=true`, `setsebool -P virt_sandbox_use_nfs=true`

#### Reclamation Policies: Recycling

NFS implements the OpenShift Container Platofmr Recyclable plug-in interface. Automatic processes handle reclamation tasks based on policies set on each persistent volume. By default, persistent volumes are set to `Retain`. The `Retain` reclaim policy allows for manual reclamation of the resource. When the persistent volume is deleted, the persistent volume still exists and the volume is considered released. But it is not yet available for another claim because the data from the previous claim remains on the volume. However, an administrator can manually reclaim the volume.

NFS volumes with their reclamation policy set to `Recycle` are scrubbed after being released from their claim. For example, when the reclamation policy is set to Recycle on an NFS volume, the command `rm -rf` is ran on the volume after the user's persistent volume claim bound to the volume is deleted. After it has been recycled, the NFS volume can be bound to a new claim.

### Using FS Groups for Block Storage-Based Volumes

For file-system groups, an fsGroup defines a pod's "file-system group" ID, which is added to the containers supplemental groups. The supplemental group ID applies to shared storage, whereas the fsGroup ID is used for block storage.

Block storage, such as Ceph RBD, iSCSI, and cloud storage, is typically dedicated to a single pod. Unlike shared storage, block storage is taken over by a pod, meaning that user and group IDs supplied in the pod definition (or image) are applied to the actual, physical block device. Block storage is normally not shared.

### SELinux and Volume Security

All predefined security context constraints, except for the privileged security context constraint, set the `seLinuxContext` to `MustRunAs`. The security context constraints most likely to match a pod's requirements force the pod to use an SELinux policy. The SELinux policy used by the pod can be defined in the pod itself, in the image, in the security context constraint, or in the project (which provides the default).

SELinux labels can be defined in a pod's `securityContext.seLinuxOptions` section, and supports `user`, `role`, `type`, and `level` labels.

##### SELinux Context Options

*MustRunAs*

Requires `seLinuxOptions` to be configured if not using preallocated values. Uses `seLinuxOptions` as the default. Validates against `seLinuxOptions`.

*RunAsAny*

No default provided. Allows any `seLinuxOptions` to be specified.
