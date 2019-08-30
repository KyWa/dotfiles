# Red Hat Virtualization Structure

More info can be found at [Red Hat Documentation](https://access.redhat.com/documentation/en/red-hat-virtualization)

### RHV-M

Red Hat Virtualization Manager. Can be self-hosted or an appliance (easiest and current recommended install). Stores data in a PostgreSQL database (internal or external).

### Hosts

RHV supports two types of hosts, RHV-H (Red Hat Virtualization Host) or RHEL with Virtualization. Hosts exist in clusters, which exist in datacenters. Hosts can be migrated between clusters and datacenters. Requires maintenence mode.

### Storage

Storage domains are configured to provide hypervisor hosts access to virtual machine disk images, templates, and ISO files. RHV supports various platforms (NFS, Gluster, or other POSIX-compliant file systems). 3 typical storage domains:

* Data Domains hold virtual machine disk images as well as templates
* ISO Domains store media images used for deployment of virtual machines but are now deprecated. Recommended practice is to use a data domain.
* Export Domains connect to and disconnect from one data center at a time as  atransport mechanism for moving virtual machines between data centers. This has also been deprecated.
