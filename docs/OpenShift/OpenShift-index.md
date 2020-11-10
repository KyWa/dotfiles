# OpenShift

* [Disconnected](Disconnected)
* [Resource Management](ResourceManagement)
* [Logging and Monitoring](Logging-Monitoring)
* [Access and Security](Access-Security)
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
