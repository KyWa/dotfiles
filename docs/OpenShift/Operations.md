# OpenShift Operations

## Dump to be sorted
OCP4 clusters are managed via Operators
    - created during installation
    - managed through custom resources
Cluster "manages itself"
    - OS is handled by OCP (RHCOS for sure, need to verify on RHEL based)
Cluster upgrades handled by cluster after deployment
Cluster configuration handled by changing custom resources

Nodes/Machines can be found in the `openshift-machine-api` namespace. `oc get nodes` still works. Due to the nature of the provisioner, the machines themselves are listed in more detail under the aforementioned namespace
The MachineSet object allows an administrator to request a preferred number of machines replicated from a common Machine template.
Machinesets manage and watch machines for changes. Machines create infra(vm) to become nodes
