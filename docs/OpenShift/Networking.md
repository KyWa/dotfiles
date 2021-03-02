# OpenShift Networking

The Container Network Interface (CNI) is a common interface between the network provider and the container execution and is implemented as network plug-ins. The CNI provides the specification for plug-ins to configure network interfaces inside containers. Plug-ins written to the specification allow different network providers to control the OpenShift cluster network.

The SDN uses CNI plug-ins to create Linux namespaces to partition the usage of resources and processes on physical and virtual hosts. This implementation allows containers inside pods to share network resources, such as devices, IP stacks, firewall rules, and routing tables. The SDN allocates a unique routable IP to each pod so that you can access the pod from any other service in the same network.

The common CNI plug-ins used in OpenShift are `OpenShiftSDN`, `OVN-Kubernetes`, and `Kuryr`. `OpenSHiftSDN` is the default in OCP 4 currently, but may switch later to `OVN-Kubernetes`.

The `OpenShiftSDN` network provider uses `Open vSwitch` (OVS) to connect pods on the same node and `Virtual Extensible LAN` (VXLAN) tunneling to connect nodes. `OVN-Kubernetes` uses `Open Virtual Network` (OVN) to manage the cluster network. OVN extends OVS with virtual network abstractions. `Kuryr` provides networking through the Neutron and Octavia Red hat OpenStack Platform services.

## DNS

The DNS Operator deploys and runs a DNS server managed by CoreDNS (lightweight DNS server written in GoLang). The DNS operator provides DNS name resolution between pods, which enables services to discover their endpoints. Everytime a new application is created, OpenShift configures the pods so they can contact the CoreDNS service IP for DNS resolution.

The DNS operator is responsible for the following:
* creating a default cluster DNS name (`cluster.local`)
* Assigning DNS names to servieces that are defined (`db.backend.svc.cluster.local`)

## Cluster Network Operator

OCP uses the Cluster Network Operator for managing the SDN. This includes the network CIDR to use, the network provider, and the IP address pools. Configuration of the Cluster Network Operator is done before installation, although it is possible to migrate from the OpenShift SDN default CNI network provider to the OVN-Kubernetes network provider.

The SND is managed by the CRD: `Network.config.openshift.io` and can be viewed via (some output omitted):

```yaml
[admin@cluster ~]$ oc get network/cluster -o yaml
apiVersion: config.openshift.io/v1
kind: Network
spec:
  clusterNetwork:
  - cidr: 10.128.0.0/14
    hostPrefix: 23
  externalIP:
    policy: {}
  networkType: OpenshiftSDN
  serviceNetwork:
  - 172.30.0.0/16
```

## Routers

Provides automated load balancing to pods for external clients. Routers (and the actual Routes) can autoroute around unhealthy pods. The routing layer is pluggable and extensible. Can include non-OpenShift software routers.

### Route

A Route exposes a `service` by giving it an externally reachable hostname. A Route consists of a route name, service selector and optional security config. A router can consume defined Route and endpoints identified by a `service`.
