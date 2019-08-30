# OpenShift Networking

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


## SDN

In 3.9 you can configure 3 different SDNs:

* The `ovs-subnet` plug-in, which is the default plug-in. `ovs-subnet` provides a flat pod network where every pod can communicate with every other pod and service.
* The `ovs-multitenant` plug-in provides an extra layer of isolation for pods and services. When using this plug-in, each project receives a unique Virtual Network ID ( `VNID` ) that identifies traffic from the pods that belong to the project. By using the VNID, pods from different projects cannot communicate with pod and services from a different project. *NOTE* Projects with a `VNID` of `0` are top level and can communicate with all other projects and pods and vice-versa. The `default` project has a `VNID` of `0`
* The `ovs-networkpolicy` is a plug-in that allows administrators to define their own isolation policies by using the `NetworkPolicy` objects.

The cluster network is established and maintained by OpenShift SDN, which creates an overlay network using Open vSwitch. Master nodes do not have access to containers via the cluster network unless administrators configure them to act as nodes.


## Getting Traffic into and out of the Cluster

By default pod and service IP addresses are not reachable from outside the OCP Cluster. There are 3 methods to allow access outside of the cluster:

* `HostPort`/`HostNetwork` - In this approach, clients can reach application pods in the cluster directly via the network ports on the host. Ports in the application pod are bound to ports on the host where they are running. This approach requires escalated privileges to run, and there is a risk of port conflicts when there are a large number of pods running in the cluster.
* `NodePort` - This is an older Kubernetes-based approach, where the service is exposed to external clients by binding to available ports on the node host, which then proxies connections to the service IP address. Use the oc edit svc command to edit service attributes, specify `NodePort` as the type, and provide a port value for the `nodePort` attribute. OpenShift then proxies connections to the service via the public IP address of the node host and the port value set in `nodePort` . This approach supports non-HTTP traffic.
* OpenShift `routes` - This is the preferred approach in OpenShift. It exposes services using a unique URL. Use the oc expose command to expose a service for external access, or expose a service from the OpenShift web console. In this approach, only HTTP, HTTPS, TLS with SNI, and WebSockets are currently supported.

*Minimal Service Definition*
```yaml
apiVersion: v1
kind: Service
metadata:
...
spec:
  ports:
  - name: 3306-tcp
    port: 3306
    protocol: TCP
    targetPort: 3306 
    nodePort: 30306
  selector:
    app: mysqldb
    deploymentconfig: mysqldb
    sessionAffinity: None
  type: NodePort
...
```

OpenShift binds the service to the value defined in the `nodePort` attribute and the port is opened on all nodes in the cluster. The requests are round-robin load balanced between the pods behind the service. Port numbers for `NodePort` attributes are restricted to the range of 30000-32767 by default. It is configurable in the OpenShift master configuration file. If a `nodePort` is not assigned a random one will be chosen.

### Routes

The default subdomain for the cluster is in the file `master-config.yaml` on the Master node(s). 

```yaml
routingConfig:
  subdomain: apps.example.com
```

Routes can be secured or unsecured. Secure routes provide the ability to use several types of TLS termination to serve certs to the client. A secured route specifies the TLS termination of the route. These types are listed below:

* Edge Termination - With edge termination, TLS termination occurs at the router, before the traffic gets routed to the pods. TLS certificates are served by the router, so they must be configured into the route, otherwise the router’s default certificate is used for TLS termination. Because TLS is terminated at the router, connections from the router to the endpoints over the internal network are not encrypted.

* Pass-through Termination - With pass-through termination, encrypted traffic is sent straight to the destination pod without the router providing TLS termination. No key or certificate is required. The destination pod is responsible for serving certificates for the traffic at the endpoint. This is currently the only method that can support requiring client certificates (also known as two-way authentication).

* Re-encryption Termination - Re-encryption is a variation on edge termination, where the router terminates TLS with a certificate, then re-encrypts its connection to the endpoint, which might have a different certificate. Therefore the full path of the connection is encrypted, even over the internal network. The router uses health checks to determine the authenticity of the host.

*Example of creating a secure route*
```sh
openssl genrsa -out example.key 2048
openssl req -new -key example.key -out example.csr -subj "/C=US/ST=TX/L=Houston/O=Example/OU=IT/CN=test.example.com"
openssl x509 -req -days 366 -in example.csr -signkey example.key -out example.crt
oc create route edge --service=test --hostname=test.example.com --key=example.key --cert=example.crt
```

## Sizing Impacts on Networking

OpenShift clusters need two different network CIDRs defined in order to assign pod and service IP addresses to its own components and the workloads running on it. THese two values are the `pod network CIDR` and the `services network CIDR`. These are not routable outside of the cluster, but must not coincide with actual external network CIDRs or issues can occur inside the cluster.

The variable `osm_cluster_network_cidr` determines the network size for the pod IP addresses in the cluster. A /14 (example: `10.128.0.0/14`) would yield 262k IPs for pods. The variable `openshift_portal_net` determines the network size for services in the cluster. These 2 variables default to a /14 and /16 respectively, but Red Hat recommends setting them explicitly.

#### Master Service Ports

The following two variables default to what is listed if not set. You can set them to `443` to avoid appending port numbers to the URLs.

* `openshift_master_api_port=8443`
* `openshift_master_console_port=8443`

