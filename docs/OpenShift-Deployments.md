# Kubernetes / OpenShift Deployments

To look at which templates exist in an OpenShift clsuter run `oc get templates -n openshift` where `openshift` is the namespace you wish to view. To view detailed output of a specific tempalte you will run `oc get template <template-name> -n <namespace> -o yaml`.
