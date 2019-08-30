# Post Installation Tasks

At the start, there is not a cluster admin. To create one in `ocp` you need to run something like the following:

`oc adm policy add-cluster-role-to-user cluster-admin username`

This will make the `admin` user a cluster admin for the whole of the `ocp` cluster. Also, verify that the nodes and pods are running in the cluster with `oc get nodes` and `oc get pods`.
