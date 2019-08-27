# RHV Storage

NFS Storage needs perms of 36:36 (vsdm:kvm) on the exported directory.

Storage needs to be built and defined before installation. NFS is an easy option (and was mandatory for some data stores in previous versions). A data domain must be present in a datacenter before it can come online or have other storage domains added.

## Storage Domain Overview

A storage domain is a collection of images with a common storage interface. A storage domain contains images of templates, virtual machines, snapshots, and ISO files. A storage domain is made of either block devices (iSCSI, FC) or a file system (NFS, GlusterFS).

On file system backed storage, all virtual disks, templates, and snapshots are files. On block device backed storage, each virtual disk, template, or snapshot is a logical volume. Block devices are aggregated into a logical entity called a volume group, and then divided by LVM (Logical Volume Manager) into logical volumes for use as virtual hard disks.

Virtual disks use either the QCOW2 or raw format. Storage can be either sparse or preallocated. Snapshots are always sparse, but can be taken for disks of either format. Virtual machines that share the same storage domain can migrate between hosts in the same cluster.

## Describing the Storage Pool Manager

The host that can make changes to the structure of the data domain is known as the Storage Pool Manager (SPM). The SPM coordinates all metadata changes in the data center, such as creating and deleting disk images, creating and merging snapshots, copying images between storage domains, creating templates, and storage allocation for block devices. There is one SPM for every data center. All other hosts can only read storage domain structural metadata.

All hosts can read and write to stored images within a storage domain, but only the SPM can apply changes to the configuration of storage domains. Either manually enable a host as the SPM, or let RHV-M select one automatically.


## Storage Domain Types

Red Hat Virtualization supports three types of storage domains. Beginning in RHV 4, the ISO and export storage domains are deprecated, but remain available and supported. Functionality for ISO and export storage domains is now handled by data storage domains.

### Data Storage Domain

A data storage domain stores hard disk images for virtual machines. These disk images can contain the operating system or other virtual machine data. ISO disk images, used to install operating systems and applications, are uploaded to a data domain. When creating a new virtual machine, an ISO image from a data storage domain is attached as a virtual CD/DVD drive. Data storage domains support NFS, iSCSI, FC, GlusterFS and POSIX compliant storage backing. Every RHV data center must have at least one data storage domain. A data domain can be associated with only one RHV data center at a time.

### ISO Storage Domain

An ISO storage domain stores disk images used to install virtual machine operating systems and applications. These are ISO 9660-formatted CD or DVD images. Unlike the data storage domain, the ISO storage domain can store only ISO images and not hard disk images. Only one ISO domain is needed in a data center, and a single ISO domain can be shared by multiple data centers in a deployed RHV environment. An ISO storage domain supports the NFS, GlusterFS, and POSIX compliant storage backing.

### Export Storage Domain

An export storage domain holds hard disk images and virtual machine templates to transfer between data centers. An export storage domain can be attached to only one data center at a time. To share the domain contents across data centers, detach the export storage domain from the current data center and attach it to the intended data center. Export storage domains support the NFS, GlusterFS, and POSIX compliant storage backing.
