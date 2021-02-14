# OpenShift Networking

The Container Network Interface (CNI) is a common interface between the network provider and the container execution and is implemented as network plug-ins. The CNI provides the specification for plug-ins to configure network interfaces inside containers. Plug-ins written to the specification allow different network providers to control the OpenShift cluster network.

The SDN uses CNI plug-ins to create Linux namespaces to partition the usage of resources and processes on physical and virtual hosts. This implementation allows containers inside pods to share network resources, such as devices, IP stacks, firewall rules, and routing tables. The SDN allocates a unique routable IP to each pod so that you can access the pod from any other service in the same network.

The common CNI plug-ins used in OpenShift are `OpenShiftSDN`, `OVN-Kubernetes`, and `Kuryr`. `OpenSHiftSDN` is the default in OCP 4 currently, but may switch later to `OVN-Kubernetes`.

The `OpenShiftSDN` network provider uses `Open vSwitch` (OVS) to connect pods on the same node and `Virtual Extensible LAN` (VXLAN) tunneling to connect nodes. `OVN-Kubernetes` uses `Open Virtual Network` (OVN) to manage the cluster network. OVN extends OVS with virtual network abstractions. `Kuryr` provides networking through the Neutron and Octavia Red hat OpenStack Platform services.

## Routers

Provides automated load balancing to pods for external clients. Routers (and the actual Routes) can autoroute around unhealthy pods. The routing layer is pluggable and extensible. Can include non-OpenShift software routers.

### Route

A Route exposes a `service` by giving it an externally reachable hostname. A Route consists of a route name, service selector and optional security config. A router can consume defined Route and endpoints identified by a `service`.
