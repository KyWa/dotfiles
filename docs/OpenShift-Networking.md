# Kubernetes and OpenShift Networking

Each container gets an IP from the cluster handed out by the SDN run by Kubernetes. Services are used to target specific pods instead of bothering with IPs as they change far to often. External access is done by applying the `NodePort` attribute which is a network port redirected by all the cluster nodes to the SDN. OpenShift handles external access via Routes. Routes define an external-facing DNS name and ports for a service. A router (ingress controller) forwards HTTP and TLS requests to the service address inside the Kubernetes SDN. The only requirement is that the desired DNS names are mapped to the IP addresses of the RHOCP router nodes.

Kubernetes has no easy way for pods to find the IPs of other pods/containers, Services are used to target other pods instead.

In OpenShift, a route connects a public-facing IP address and DNS hostname to an internal-facing service IP. It uses the service resource to find the endpoints aka the ports exposed by the service. The router service uses HAProxy by default. 

*Minimal Route Definition*

```json
{
    "apiVersion": "v1",
    "kind": "Route",
    "metadata": {
        "name": "quoteapp"
    },
    "spec": {
        "host": "quoteapp.apps.example.com",
        "to": {
            "kind": "Service",
            "name": "quoteapp"
        }
    }
}
```

`oc new-app` does not create a route resource when building a pod. `oc expose service` will create a route when passing in a service resource name. The `--name` option can be used to control the name of the route resource. (ex. `oc expose service quotedb --name quote`). By Default routes created by `oc expose` generate DNS names in the form: `route-name - project-name . default-domain`. 
