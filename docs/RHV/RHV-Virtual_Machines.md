# Virtual Machines

#### Supported Operating Systems

| Operating System             | Version                                    |
| ---                          | ---                                        |
| Red Hat Enterprise Linux     | 3, 4, 5, 6, 7, 8                           |
| Microsoft Windows Server     | 2008, 2008 (R2), 2012, 2012 R2, 2016, 2019 |
| Microsoft Windows            | 7, 8, 8.1, 10                              |
| SUSE Linux Enterprise Server | 10, 11, 12, 15                             |

Instance Type Configuration

#### Desktop

* Enable all USB devices
* Enable the Smart Card device
* Use an Image with Thin Allocation
* Instance is Stateless

#### Server

* Disable the Sound Card device
* Use a Cloned Disk Image
* Instance is Not Stateless

#### HPC (High Performance Compute)

* Enable Headless Mode and enable Serial console
* Disable all USB devices
* Disable the Sound Card device
* Disable the Smart Card device
* Enable Pass-Through Host CPU
* Disable VM migration
* Enable IO Threads, Num Of IO Threads = 1
* Disable the Memory Balloon Device
* Enable High availability only for pinned hosts
* Disable the Watchdog device
* Enable paravirtualized Random Number Generator PCI (virtio-rng) device
* Enable Multi Queues per Virtual Interface
* Set the IO and Emulator threads pinning topology


## Snapshots

### Snapshots of Virtual Machines

A snapshot is a view of a virtual machine that includes the operating system and applications on any or all available disks at a given point in time. An administrator may take a snapshot of a virtual machine before making changes to it. This can protect against errors that might have unintended consequences. If there is a problem, the administrator can revert the state of the virtual machine to one recorded by the snapshot.

Red Hat Virtualization allows you to take live snapshots of running virtual machines, as well as snapshots of stopped virtual machines. RHV-M supports several snapshots of a virtual machine, but it can only use a single snapshot at a time.

You can shut down the virtual machine and permanently roll the disk image back to an earlier snapshot. When you do, RHV-M discards all snapshots taken at later points in time. Before committing to the rollback, you can temporarily preview a particular snapshot by booting it to confirm that it is the one you want to use.

Snapshots can also be used to create new virtual machines. You can clone a virtual machine from an older snapshot rather than cloning directly from a current virtual machine. A clone is a copy of that virtual machine on new hardware. Be aware that a clone is likely to have machine specific data and configuration settings from the original virtual machine. This may or may not be desired. As an alternative, you can use a snapshot to create a "sealed template" that can be used to create virtual machines from an image that has had this machine specific information cleared.

### Creating a Snapshot of a Virtual Machine
Red Hat Virtualization allows you to manually create snapshots for virtual machines with the Administration Portal. A virtual machine needs the RHV guest agent to create a consistent snapshot.

Snapshots are created in the Compute → Virtual Machines menu of the Administration console. Right-click the virtual machine to use as the source of the snapshot, and then select Create Snapshot from the menu. The Create Snapshot window displays. The virtual machines disks are automatically selected. However, one or more disks can be deselected when creating the snapshot. Enter a description for the snapshot in the Description field.

If the virtual machine is running, you may select the Save Memory check box to save the memory state of the virtual machine in the snapshot. The resulting snapshot looks like a suspended version of the virtual machine. Click OK to create the snapshot.

After clicking on OK, click on the name of the virtual machine. Then, click on Snapshots. Watch the snapshot display in the bottom window. Click on General. The status should display OK. It may take a minute or so for this value to transition from `Locked` to `OK`.

### Rolling Back to an Earlier Snapshot
Once you have a snapshot, you can shut down the original virtual machine and relaunch it using an earlier snapshot. You have the option to preview the snapshot before committing to the rollback. In this mode, the virtual machine runs using the virtual image of the snapshot. This allows you to confirm that you have the right snapshot selected.

When you are ready, you can permanently commit to the rollback. The active image for the virtual machine reverts to the snapshot, and all snapshots newer than the one selected for rollback are permanently discarded.

To preview and roll back a virtual machine state using a snapshot, click the Compute → Virtual Machines menu item in the Administration Portal. Select a virtual machine from the list, and make sure that it has been shut down. Select the Snapshots tab for the virtual machine by clicking on the name of the virtual machine, and then clicking on the Snapshots tab. Find the snapshot that you want to restore and select it from the list.

To see information about the snapshot, click the Preview button. If the snapshot has a saved memory state, then a window opens with a prompt to restore memory. The snapshot moves to the state IN_PREVIEW, which indicates that it is ready to run. In Preview mode, you are simply trying to decide if you have selected the correct snapshot. If you Undo the preview, then any changes you make are discarded. If you Commit the snapshot, then changes made in the preview are retained.

To run the preview on a temporary basis, click on Run from the Snapshots tab. When you have decided whether or not to roll back to that snapshot, you can shut down the virtual machine.

If you have decided to roll back to that snapshot permanently, then click the Commit option on the Snapshots tab. This rolls the state of your virtual machine back to that snapshot on a permanent basis, and discards any snapshots that were taken more recently. Then, Run the virtual machine normally to restart it.

Alternatively, if you decide not to roll back to that snapshot, click the Undo option on the Snapshots tab. The snapshot changes state from In Preview to OK, and your original image changes state from `Locked` to `OK`. You can now run the virtual machine normally, or you can try rolling back to a different snapshot.

    ### WARNING
    The decision to commit to a particular snapshot is irreversible. The formerly current image state, any snapshot newer than the snapshot you committed, and all unique associated data, is permanently lost.
    
### Cloning a Virtual Machine from a Snapshot
Any existing snapshot can be used to clone a virtual machine. Remember, a clone is a copy of a virtual machine created on new hardware. It can be useful to create a clone from a snapshot instead of a current virtual machine, for example, to make a copy of some older state of that virtual machine. Alternatively, you may want to permanently revert to an earlier snapshot, and you may want to clone later snapshots before they are deleted.

To clone a virtual machine from an existing snapshot, click on Compute, then click on Virtual Machines in the Administration Portal and select a virtual machine from the list. Select the Snapshots tab for the virtual machine by clicking on the name of the virtual machine, then clicking on the Snapshots tab. Find the snapshot you want to clone and select it from the list, and then click Clone. This opens a new window, Clone VM from Snapshot, which is very similar to the New Virtual Machine window.

At a minimum, set a Name for the cloned virtual machine. You can customize other details as well. Then, click OK to create the cloned virtual machine.

Watch the status of the virtual machine on the Compute → Virtual Machines tab. Once the status switches to Down, you may run the new machine.

    ### NOTE
    A cloned virtual machine may still have data from its source image. You might not want this if you are trying to create a new virtual machine with a similar configuration rather than an exact copy.

    As an alternative, you can use the snapshot to create a sealed template that has been cleared of unique data, and then create virtual machines from that template. A template can be created from a snapshot by using the Make Template option instead of Clone.
    
    
## Importing and Exporting Virtual Machine Images

### Managing Virtual Machine Images
RHV-M stores virtual machine disk images in data domains. A data domain can be attached to only one data center at a time. However, a single data center can have multiple data domains attached simultaneously.

A disk image is stored in a single data center, but it can be relocated to another. There are multiple relocation methods available, including:

Moving a disk image for a virtual machine from one data domain to another data domain.

Exporting virtual machines from one data center and importing them into another data center.

Importing an existing QCOW2 image from outside RHV into a data domain, and then attaching it to a virtual machine.

The current RHV version can import images directly into data domains, and move data domains from one data center to another. Previous versions of RHV used an export domain to export and import images between data domains. Export domains are being deprecated, but are still available for use when needed.

### Importing Virtual Machine Images into RHV
The latest RHV version uses the Administration Portal, or the API, to directly import QCOW2 formatted disk images into a data domain. Disk images can then be attached to existing virtual machines in the data center.

To import images with this method, RHV-M must be configured to provide the Image I/O Proxy. When importing, the Administration Portal, or the API, must be able to validate the request. Your browser must import the RHV-M CA certificate, which must be configured to trust its usage for web sites, and also support the necessary HTML5 APIs. The browsers that support specific RHV versions are found in the Red Hat documentation.

To import a virtual machine image using the Administration Portal, click Storage, and then click on Disks . Select Upload → Start.

The Upload Image window displays. In the window, click Choose File, and then select the image to upload from your local system. Specify a size to make the image, an Alias for its name, and the Data Center and Storage Domain to store it in. Click OK to start the import.

The image appears on the list in the Disks tab. A progress bar displays underneath it as it uploads. When RHV-M finishes the image upload, its status changes to OK. Note that it is not yet attached to any virtual machine.

To attach a disk image to an existing virtual machine using the Administration Portal, select Compute in the menu bar, and then click on Virtual Machines tab. Click on the name of the virtual machine to which you want to attach the image. Select the Disks tab for that virtual machine at the bottom of the interface. This lists all disk images attached to the virtual machine.

If the virtual machine has any disks already attached that you want to delete, click Remove. A window opens asking you to confirm the disk removal. If you want the disk deleted from the data domain entirely, select the Remove permanently check box.

To add the imported disk image, click Attach. A window opens, listing all disk images. Select the check box next to the disk image you want to attach. Adjust its Interface to use the desired connection protocol. Finally, if this is the boot disk for the system, select the check box under the circled letters OS (Operating System). Click OK to attach the disk to your virtual machine.

#### Importing VM Images using Export Domains
An older method to import virtual machine images used export domains to import and export virtual machines in Open Virtualization Format (OVF). Export domains were also used to transfer images from one data domain to another in different data centers.

    ### NOTE
    Export domains have been deprecated in Red Hat Virtualization 4.1, but are currently still available and supported, as they may have practical use cases. For example, the guided exercise following this lecture uses an export domain.
    
First, an export domain must be created and attached to the data center for the new virtual machine. To create an Export domain, click on the Storage menu, and then click on Domains. Select Export as the domain function.

To upload an image to the Export domain, click on the domain name, and then click on VM Import. A list of all available virtual machines to import displays. Click on the virtual machine to import, and then click on Import.

The Import Virtual Machine(s) window opens. Name the new virtual machine, and then click OK to import it into the data domain and the data center.

#### Exporting VM Images using Export Domains
When RHV-M exports a virtual machine into an export domain, it puts the OVF Package for the virtual machine in a directory structure in that export domain. This directory structure includes two subdirectories: images and master. The directories which comprise the OVF Package include an "OVF file" which is named with the .ovf file extension. This is a descriptor file that specifies the virtual hardware configuration for the virtual machine. The directories also include virtual disk image files for that virtual machine. An OVA file or package is just a TAR archive of the OVF Package directory structure.

If you can directly access the storage for the export domain, this provides an unsupported way to extract virtual machines from Red Hat Virtualization.

The official way to extract images from Red Hat Virtualization is to use its API. For more information, see the Red Hat Virtualization REST API Guide.

#### Virtual-2-Virtual Migration
Virtual-2-Virtual migration, or V2V, is a tool to move virtual machines from one data center to another. The virt-v2v tool is included in Red Hat Enterprise Linux 7 and Red Hat Enterprise Linux 8. This tool can convert virtual machines for use with Red Hat Virtualization Platform, as well as Red Hat OpenStack Platform and KVM.
    
### Moving VM Disks to a New Data Domain
If a particular data domain is getting full or its usage is high, you may want to move some virtual machine disks to another data domain in the data center. You can also export virtual machines to a new data center by moving them into a new data domain, and then moving the data domain to another data center.

Red Hat Virtualization supports the manual migration of virtual machine disks from one data domain to another. To move virtual machine disks to a new data domain using the Administration Portal, click on the Storage menu item, then click on Disks. Select the disk(s) associated with the virtual machine and click Move.

The Move Disk(s) window opens. For each disk, select the destination data domain in the Target and the Disk profile fields. Click OK to move the virtual machine disks to the destination data domain. It may take up to a minute for the virtual machine disks to move.

In the Disks window, click on each disk entry. A new window displays providing information about the disk. Click on the Storage tab, and then verify that the destination data domain is listed.

### Exporting Virtual Machines to a Different Data Center
RHV-M supports the usage of data domains to move virtual machine images between data centers. A data domain must store the virtual machine images. To export a virtual machine between data centers using a data domain in the Administration Portal, click on Storage, and then click on Domains. Select the row for the data domain. A new window opens with the data domain configuration.

In the new window, go to the Data Center tab, and then click Maintenance to move the data domain into maintenance mode in the source data center. All virtual machines using the data domain should be powered off to move a data domain into maintenance mode.

A Storage Domain maintenance window opens, asking you to confirm that you want to move the data domain into maintenance mode. Click OK. When the value of the Domain status in Data Center field for the source data center displays `Maintenance`, click Detach to detach the data domain from the source data center.

A window titled Detach Storage opens. Click OK to detach the data domain from the source data center. Once detached, the source data center no longer appears in the Data Center tab for the data domain configuration details section. In the same tab, click Attach.

The Attach to Data Center window opens. Select the radio button for the destination data center. Click OK to attach the data domain to the destination data center.

In the data domain configuration details section, go to the VM Import tab. This tab includes a list of virtual machine images stored in the data domain. Select a virtual machine and click Import.

The Import Virtual Machine(s) window opens. Select the cluster of the destination data center. Click OK to import the virtual machine.

Click Compute in the left navigation pane, and then select Virtual Machines. Verify that the imported virtual machine is listed, and that its status is `Down`.

## Highly Available VMs

High Availability for Virtual Machines
A high availability virtual machine is automatically restarted if it crashes or if its host becomes non-responsive. When these events occur, RHV-M automatically restarts the high availability virtual machine, either on its original host or another host in the cluster.

Red Hat Virtualization Manager constantly monitors hosts and storage to detect hardware failures. With high availability, interruption to service is kept to a minimum because RHV-M restarts virtual machines configured to be highly available within seconds with no user intervention required.

Configuring high availability is a recommended practice for virtual machines running critical workloads.

    ### IMPORTANT
    There is an important distinction between a Non-Operational host and a Non-Responsive host.

    A non-operational host has a problem but RHV-M can still communicate with it. RHV-M works with the host to migrate any virtual machines running on that host to operational hosts in the cluster. Likewise, a host that is moved to Maintenance mode automatically migrates all its virtual machines to other operational hosts in the cluster.

    A non-responsive host is one that is not communicating with RHV-M. After about 30 seconds, RHV-M fences that host and restarts any highly available virtual machines on operational hosts in the cluster.

Virtual machines may be configured to automatically restart if the host becomes non-responsive or the virtual machine unexpectedly crashes. To use this feature, all hosts in the cluster must support an out-of-band power management system such as iLO, DRAC, RSA, or a network-attached remote power switch configured to act as a fencing device.

RHV-M can also automatically restart high-priority virtual machines first. Multiple levels of priority give the highest restart priority to the most important virtual machines.

Virtual machines are configured to be highly available on an individual basis. It can be configured when you create the virtual machine, or you can edit the VM to enable high availability.
