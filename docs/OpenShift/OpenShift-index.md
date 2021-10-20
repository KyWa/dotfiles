# OpenShift

* [Disconnected](Disconnected)
* [Resource Management](ResourceManagement)
* [Logging and Monitoring](Logging-Monitoring)
* [Authentication and Authorization](Authentication-Authorization)
* [Networking](Networking)
* [ControlPlane](ControlPlane)
* [GPU](GPU)
* [AppDev](AppDev)
* [Common](Common)
* [Operations](Operations)
* [Troubleshooting](Troubleshooting)

OCP 4 is a Platform based on Kubernetes. The control plane can only be deployed on RHCOS (Red Hat CoreOS). Worker nodes can be any node that runs RHEL. This includes RHEL 7/8+ as well as RHCOS. RHCOS is FIPS-compliant.

    # Note
    RHCOS is only available for OCP 4 and not available for general use
    
    
## Random Things to be placed later

```bash
oc completion bash > oc_bash_completion
sudo cp oc_bash_completion /etc/bash_completion.d/
oc get appliedclusterresourcequotas (if multiple quotas, see which is applied)
oc api-versions (gets all apiendpoints/versions)
oc get oauthaccesstokens
oc login --loglevel=9 (verbose path of login method)
oc adm new-project openshift-* (to create a project prefixed with openshift, you must use oc adm first)
oc policy who-can VERB KIND (find out who can do what)
oc policy --as=USER/GROUP can-i VERB KIND
```

## 3.11 Things
Kubelet Arguments for image pulls
```yaml
image-pull-progress-deadline:
       - "5m"
```

## Red Hat Registries
The [Red Hat Container Catalog](https://access.redhat.com/containers) presents a unified view of three underlying container registries:

### Red Hat Container Registry at [registry.access.redhat.com](registry.access.redhat.com)
It is a public registry that hosts images for Red Hat products and requires no authentication. Note that, while this container registry is public, most of the container images that Red Hat provides require that the user has an active Red Hat product subscription and that they comply with the product's End-User Agreement (EUA). Only a subset of the images available from Red Hat's public registry are freely redistributable. These are images based on the Red Hat Enterprise Linux Universal Base Images (UBI).

### Red Hat terms-based registry at [registry.redhat.io](registry.redhat.io)
It is a private registry that hosts images for Red Hat products, and requires authentication. To pull images from it, you need to authenticate with your Red Hat Customer Portal credentials. For shared environments, such as OpenShift or CI/CD pipelines, you can create a service account, or authentication token, to avoid exposing your personal credentials.

### Red Hat partner registry at [registry.connect.redhat.com](registry.connect.redhat.com)
It is a private registry that hosts images for third-party products from certified partners. It also needs your Red Hat Customer Portal credentials for authentication. They may be subject to subscription or licenses at the partner's discretion.

`oc create secret docker-registry NAME`
`oc secrets link SERVICEACCOUNT NAME --for pull`
`oc secrets link builder NAME`
