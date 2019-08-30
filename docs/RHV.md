# Red Hat Virtualization

* [Installation](RHV-Installation)
* [Virtual Machines](RHV-Virtual_Machines)
* [Access and Security](RHV-Access)
* [Networking](RHV-Networking)
* [Management](RHV-Management)
* [Storage](RHV-Storage)
* [Components](RHV-Components)
* [Troubleshooting](RHV-Troubleshooting)


### RHV Supporting Infrastructure

Due to the many parts required to provision a resiliant RHV environment, it is imperative to take into account other systems and services required to maintain a functioning environment.

DNS is critical for RHV to operate correctly. Ensure that forward and reverse name resolution is functioning correctly for hosts and the Red Hat Virtualization Manager and that fully-qualified domain names are used.

A number of services, especially related to authentication and TLS/SSL certificates, are sensitive to time skew issues. Use NTP service to ensure that system clocks are synchronized.

If you are using an external authentication provider for RHV-M users, such as Red Hat Identity Management (FreeIPA) or Microsoft Active Directory, ensure that it is highly available so that users can access the web portals. You can use local internal authentication profile users, such as the built-in admin superuser, to provide emergency access in case of an authentication outage.

You must properly test your RHV deployment prior to going into production, and identity any single points of a failure, planning accordingly.

### Storage Requirements

Selecting the right storage platform is key to avoid unnecessary issues. Good storage performance is critical to the overall performance of the RHV environment. If the storage infrastructure choices are not capable of handling its requirements, no amount of memory or CPU at the host or VM level can make up for it. Storage infrastructure design should take into account needs for data backup, data replication, application workload, and fault tolerance/high availability.

A storage environment for RHV should include the following configuration:

* Redundant Ethernet or fibre channel (FC) switches for your storage networks.
* If using iSCSI or NFS, then multiple NICs should be used and bonded, 10/40GbE NICs are recomended to improve performance.
* If using a SAN, multiple HBAs (FC) or initiators (iSCSI) should be used to provide multiple paths to the SAN. Make sure you use the same make, model, firmware version, and driver versions in the same systems and clusters to ensure consistent performance and ease troubleshooting.
* Consider using SAN-based boot if there is already a SAN available to store VMs. This configuration avoids issues related to a local host's storage and improves performance on tasks like hypervisor images cloning, speeding up virtual machine deployment times.
* GlusterFS is a scalable network based filesystem, GlusterFS relies heavily on network performance requiring high throughput NICs/network devices.

### Networking Requirements

A networking infrastructure for RHV should include the following configuration:

* Use redundant network switches.
* Use bonded network interfaces, preferably in LACP mode.
* If using Ethernet, plan at least 10GbE links for VM traffic and any Ethernet storage traffic to avoid network traffic congestion issues. Use 40GbE links if available, potentially partitioning them using VLANs as needed.
* Segregate different traffic types, like VM traffic, using Virtual LANs (VLANs). Grant different VLANs priority and available bandwidth based on their traffic, like VM live migration, user-to-VM communication or communication with the engine.
* Networks for storage and VM live migration generally need high bandwidth, and may need dedicated networks for performance and security. Bandwidth needed for virtual machine traffic varies depending on your applications. RHV-M management traffic and console display traffic is relatively low bandwidth and can use slower networks.
* VLANs, 40GbE networking, and advanced quality-of-service settings in RHV can be used together to efficiently and flexibly manage physical network configuration while segregating types of traffic and controlling bandwidth appropriately.

### Host Requirements

RHV supports hosts based on Red Hat Enterprise Linux as well as Red Hat Virtualization Host. Red Hat Enterprise Linux-based hosts can be useful for environments requiring customization at the OS level, for example, because of hardware support. However because of the manual configuration and updates performed on those hosts, Red Hat Enterprise Linux based hosts can cause unexpected issues in an RHV environment.

Red Hat recommends Red Hat Virtualization Host as the preferred operating system for hosts, because of the following features:

* Only the required packages and services supporting VMs and the hypervisor are part of RHV-H. This approach reduces operating system overhead. As an additional benefit, it also reduces the overall security "attack surface" by restricting the default configuration.
* The latest version of RHV-H allows you to install additional RPM packages if you need them, which reduces the need for "thick" Red Hat Enterprise Linux-based hosts.
* RHV-H includes the recommended configuration for a RHV host, so it does not require any manual configuration. This approach eliminates issues related to manual configuration of a system.
* RHV-H includes the Cockpit web administration tool pre-installed. This tool improves the troubleshooting of issues related to a host and its VMs.

A RHV host should also include:

* Available out-of-band (OOB) management to enable features like remote console and power control.
* Up-to-date hardware firmware and BIOS.
* Memory scaled to avoid memory swapping, which significantly degrades VM performance.
* RAID configuration of the host's local boot disks to reduce the chance of VMs going down due to host failure.

### RHV-M Considerations

You should perform backups of RHV-M on a regular basis.

Although an all-in-one (default) RHV-M installation is the preferred approach for deployment of Red Hat Virtualization Manager, for certain scenarios you may want to run some RHV-M components on separate hosts for higher performance. It is possible to deploy RHV-M components, like the PostgreSQL database, the data warehouse, and the websocket proxy, to other hosts. This does complicate RHV-M deployment and requires careful thought about redundancy, availability, and backup scenarios.

Another strategy is to deploy the RHV-M engine running as a stand alone server or a VM in a seperate environment.
