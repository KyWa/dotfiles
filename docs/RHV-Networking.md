# RHV Networking

Networking needs to be defined before installation. DHCP/DNS should not be run on VMs running on the RHV Cluster they are managing.

## Logical Networks

### Types of Logical Networks

Logical networks can be configured to segregate different traffic types on different logical networks. The initial, single default logical network, called ovirtmgmt, is configured as both a VM network and also to handle all infrastructure traffic. By default, ovirtmgmt is used for management, display and migration network traffic, in addition to VM traffic. Although this a functional configuration, it provides no boundaries between different network traffic types.

Red Hat recommends that you plan and create additional logical networks to segregate traffic. The following lists provides examples of practical traffic segregation.

### Segregating Network Traffic by Types

#### Management

This network role facilitates VDSM communication between the RHV-M and the RHV hosts. By default, it is created during the RHV-M engine deployment and named ovirtmgmt. It is the only logical network created automatically; all others are created according to environment requirements.

#### Display

This network role is assigned to a network to carry the virtual machine display (SPICE or VNC) traffic from the Administration or VM Portal to the host running the VM. The RHV host then accesses the VM console using internal services. Display networks are not connected to virtual machine vNICs.

#### VM network

Any logical network designated as a VM network carries network traffic relevant to the virtual machine network. This network is used for traffic created by VM applications and connects to VM vNICs. If applications require public access, this network must be configured to access appropriate routing and the public gateway.

#### Storage

A storage network provides private access for storage traffic from RHV hosts to storage servers. Multiple storage networks can be created to further segregate file system based (NFS or POSIX) from block based (iSCSI or FCoE) traffic, to allow different performance tuning for each type. Jumbo Frames are commonly configured on storage networks. Storage networks are not a network role, but are configured to isolated storage traffic to separate VLANs or physical NICs for performance tuning and QoS. Storage networks are not connected to virtual machine vNICs.

#### Migration

This network role is assigned to handle virtual machines migration traffic between RHV hosts. Assigning a dedicated non-routed migration network ensures that the management network does not lose connection to hypervisors during network-saturating VM migrations.

#### Gluster

This network role is assigned to provide traffic from Red Hat Gluster Servers to GlusterFS storage clusters.

#### Fencing

Although not a network role, creating a network for isolating fencing requests ensure that this critical requests are not missed. RHV-M does not perform host fencing itself but sends fence requests to the appropriate host to execute the fencing command.

### Required and Optional Networks

When created, logical networks may be designated as Required at the cluster level. By default, new logical networks are added to clusters as required networks. Required networks must be connected to every host in the cluster, and are expected to always be operational. When a required network becomes nonoperational for a host, that host's virtual machines are migrated to another cluster host, as specified by the current cluster migration policy. Mission-critical workloads should be configured to use required networks.

Logical networks that are not designated as required are regarded as optional. Optional networks may be implemented only on the hosts that will use them. The presence or absence of optional networks does not affect the host's operational status. When an optional network becomes nonoperational for a host, that host's virtual machines that were using that network are not migrated to another host. This prevents unnecessary overhead caused by multiple, simultaneous migrations for noncritical network outages. However, a virtual machine with a vNIC configured for an optional VM network will not start on a host that does not have that network available.


## Logical Network Configuration at RHV Logical Layers

Logical network configuration occurs at each layer of the RHV environment.

#### Data Center Layer

Logical networks are defined at the data center level. Each data center has the ovirtmgmt management network by default. Additional logical networks are optional but recommended. VM network designation and a custom MTU are set at the data center level. A logical network defined for a data center must be added to the clusters that use the logical network.

#### Cluster Layer

Logical networks are available from the data center, and added to clusters that will use them. Each cluster is connected to the management network by default. You can add any logical networks to a cluster if they are defined for the parent data center. When a required logical network is added to a cluster, it must be implemented on each cluster host. Optional logical networks can be added to hosts as needed.

#### Host Layer

Virtual machine logical networks are connected to each host in a cluster and implemented as a Linux bridge device associated with a physical network interface. Infrastructure networks do not implement Linux bridges but are directly associated with host physical NICs. When first added to a cluster, each host has a management network automatically implemented as a bridge on one of its NICs. All required networks in a cluster must be associated with a NIC on each cluster host to become operational for the cluster.

#### Virtual Machine Layer

Logical networks that are available for a host are available to attach to a virtual machine NIC on that host. The virtual machine then gains access to other systems and destinations available on the logical network through the connected vNIC.

#### Performance Considerations

Gigabit Ethernet is sufficient for the management network, and is typically sufficient for the display network. Any migration and storage networks you add will perform better as dedicated high-bandwidth networks or VLANs. Use 10 GbE or 40 GbE infrastructure when available. Smaller networks can be aggregated larger throughput by using network bonding or teaming. Bandwidth requirements for VM Networks must be calculated from your application requirements.
