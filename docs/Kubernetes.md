# Kubernetes and OpenShift

* [Builds](Builds)
* Storage
* Networking

In OpenShift to allow storage from the host to a container/pod you must modify the SELinux configuration via: `semanage fcontext -a -t container_file_t '/path/to/data(/.*)?'`. Don't forget to apply them via `restorecon -Rv /path/to/data`.

Registries in `podman` are modified in `/etc/containers/registries.conf`.

*Kubernetes Terminology*

| Term        | Definition                                                                                                 |
| ---         | ---                                                                                                        |
| Node        | A server that hosts applications in the cluster                                                            |
| Master Node | A node server that managed the control plane. Master nodes also serve APIs                                 |
| Worker Node | Another term: Compute Node, worker node executes workloads. App pods are schedulded onto worker nodes      |
| Resource    | Any component definition managed by Kubernetes.                                                            |
| Controller  | A Kubernetes process that watches resources and makes changes to keep desired state                        |
| Label       | A K/V Pair that can be assigned to any Kubernetes resource                                                 |
| Namespace   | A scope for Kubernetes resources and processes so like-named resources can be used in different boundaries |

[OpenShift Visual](https://role.rhu.redhat.com/rol-rhu/static/static_file_cache/do180-4.0/openshift-arch-stack.png)

*OpenShift Terminology*

| Term       | Definition                                                                  |
| ---        | ---                                                                         |
| Infra Node | Node server containing infra services (monitoring/logging/external routing) |
| Console    | A web UI provided by the RHOCP cluster                                      |
| Project    | OpenShifts extension of Kubernetes Namespaces                               |

The layout of RHOCP is as follows:

* Underlying OS is Red Hat CoreOS
* The Container Runtime (CRI-O) can be numerous things: `runc` (used by the `Docker` service), `libpod` (from `Podman`), or `rkt` (from `CoreOS`)
* `etcd` manages clsuter state and configs, Custom Resource Definitions are resource types stored in `etcd` and managed by Kubernetes
* Some services are containerized: authentication, networking, image registry
* There is also DevOps tooling on top: Web Console, CLI, REST API, SCM Integrations

[Kubernetes/OpenShift Architecture](https://role.rhu.redhat.com/rol-rhu/static/static_file_cache/do180-4.0/openshift-arch-overview-2.png)

*Describing Kubernetes Resource Types*

* Pods `po` - A collection of container(s) that share resources such as IPs and storage volumes
* Services `svc` - Define a single IP/port combo that provides access to a pool of pods. By default services connect to clients in a round-robin fashion
* Replication Controllers `rc` - A Kubernetes resource that defines how `pods` are replicated into different nodes.
* Persistent Volumes `pv` - Define storage areas to be used by Kubernetes pods
* Persistent Volume Claims `pvc` - Represent a request for storage by a `pod`. `pvc`'s links a `pv` to a `pod` so its containers can make use of it.
* ConfigMaps `cm` and Secrets - Containts a set of K/Vs that can be used by other resources. Used as a way to centralize configuration values for several resources.

*Describing Kubernetes Resource Types*

* Deployment Config `dc` - Represents the set of containers included in a `pod` and the deployment strategies to be used.
* Build Config `bc` - Defines a process to be executed in the OpenShift project. Used by the OpenShift S2I feature. `bc` and `dc` work together to provide an extensible CI/CD workflow
* Routes - Represent a DNS host name recognized by the OpenShift router as an ingress point for applications and microservices.

## Networking

Each container gets an IP from the cluster handed out by the SDN run by Kubernetes. Services are used to target specific pods instead of bothering with IPs as they change far to often. External access is done by applying the `NodePort` attribute which is a network port redirected by all the cluster nodes to the SDN. OpenShift handles external access via Routes. Routes define an external-facing DNS name and ports for a service. A router (ingress controller) forwards HTTP and TLS requests to the service address inside the Kubernetes SDN. The only requirement is that the desired DNS names are mapped to the IP addresses of the RHOCP router nodes.

Kubernetes has no easy way for pods to find the IPs of other pods/containers, Services are used to target other pods instead.

## OpenShift Usage

`oc login <clusterUrl>` - Logs you into a cluster. 


*Pod Definition Syntax*

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: wildfly
  labels:
    name: wildfly
spec:
  containers:
    - resources:
        limits :
          cpu: 0.5
      image: do276/todojee
      name: wildfly
      ports:
        - containerPort: 8080
          name: wildfly
      env:
        - name: MYSQL_ENV_MYSQL_DATABASE
          value: items
        - name: MYSQL_ENV_MYSQL_USER
          value: user1
        - name: MYSQL_ENV_MYSQL_PASSWORD
          value: mypa55
```

In the yaml file above, a few things to note are:

* `kind` specifies what the definition file is asking for, in this case its a pod
* under the metadata tag, the name variable is what will be targetable later on via CLI tools
* the labels are used to be a targetable option for services in the cluster

Some pods may require environment variables that can be read by a container. Kubernetes transforms all the `name` and `value` pairs to environment variables. For instance, the `MYSQL_ENV_MYSQL_USER` variable is declared internally by the Kubernetes runtime with a value of `user1` , and is forwarded to the container image definition. Because the container uses the same variable name to get the user's login, the value is used by the WildFly container instance to set the username that accesses a MySQL database instance.

*Example Service Definition in JSON*

```json
{
    "kind": "Service", 
    "apiVersion": "v1",
    "metadata": {
        "name": "quotedb" 
    },
    "spec": {
        "ports": [ 
            {
                "port": 3306,
                "targetPort": 3306
            }
        ],
        "selector": {
            "name": "mysqldb"
        }
    }
}
```

* `kind` is showing a Service is being created
* a name is given under metadata for the service to be targetable by
* ports is an array. In this instance, `targetPort` must match `containerPort` in a `pod` config
* `selector` is how the service finds pods to forward packets to
* each service is assigned a unique ip for clients to connect to.

For each project in OpenShift 2 env vars are created automatically and injected into containers for all pods inside the same project:

* `SVC_NAME _SERVICE_HOST` - is the service IP address
* `SVC_NAME _SERVICE_PORT` - is the service TCP port

The `SVC_NAME` part of the variable is changed to comply with DNS naming restrictions: letters are capitalized and underscores (_) are replaced by dashes (-). Another way to discover a service from a pod is by using the OpenShift internal DNS server which is only visible to `pods`. Each service is dynamically assigned an SRV record with an FQDN form: `SVC_NAME . PROJECT_NAME . svc.cluster.local`.

For applications that need access to the service outside the OpenShift cluster there are two ways to achieve this objective:

* `NodePort` type: This is an older Kubernetes based approach where the service is exposed to external clients by binding to available ports on the worker node host. This then proxies connections to the service IP address. Use the `oc edit svc` command to edit service attributes and specify `NodePort` as the value for `type` and provide a port value for the `nodePort` attribute. OpenShift then proxies connections to the service via the public IP of the worker node host and the port value assigned in `nodePort`.
* OpenShift Routes: This is the preferred approach in OpenShift to expose services using a unique URL. Use `oc expose` command to expose a service for external access or expose a service from the OpenShift web console.

[NodePort example](https://role.rhu.redhat.com/rol-rhu/static/static_file_cache/do180-4.0/kubernetes-nodeport-svc.svg)

OpenShift provides the `oc port-forward` command for forwarding a local port to a `pod` port. This is different from having access to a pod through a service resources:

* the port-forward mapping exists only to the workstation where the `oc` client runs while a service maps a port for all network users
* a service load-balances connections to multiple pods, where a port-forward mapping forwards to a single pod


