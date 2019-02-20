#Configure Local Storage

##List, Create and Delete partitions on MBR and GPT Disks

`fdisk` is a tool for managing MBR based disks/partitions. `mkfs` writes a partition table to a disk/partition. `partprobe` is used to inform the kernel of partition table changes. `gdisk` is similar to `fdisk` except it is for managing GPT based disks/partitions. 

##LVM

*Physical Volumes* (disks/partitions) can be added to a *Volume Group*. `pvcreate` does this. `pvdisplay` will show each *physical volume*. `vgcreate` will create a *Volume Group* by selecting disks that have been assigned as a *Physical Volume*. A name must be specified for the *Volume Group*. `vgdisplay` will show data about all available *Volume Groups*. `lvcreate` creates *Logical Volumes* (these function like a traditional partition). There are a few flags needed and options for creating a *Logical Volume*.

* `-n` names the *logical volume*
* `-L` specifies the size 
* *Volume Group* goes at the end of the creation

`lvcreate -n lvol01 -L 10G vg01` is an example of a *Logical Volume* creation. After it is created, it can be treated as a partion (write a filesystem and mount) to the system.  

##Persistent Disk Mounts

`/etc/fstab` is where on-boot disk mounts are placed. This can include network file shares and local disks alike. The format of `/etc/fstab` is as follows:

`what_device where_to_mount filesystem_type mount_options dump_flag fsck_order` 

`/dev/mapper/vg00-lvol01 /var/data ext4 defaults 0 0`

##Adding Swap

Create a partition via `fdisk` or `gdisk`. Must be labeled as Linux Swap if using physical partition. `mkfs` is not used to create a partition. `mkswap` is used to create a `swap` "filesystem" on the partition/logical volume. `swapon` will enable swap with all available disks with `mkswap` on. `swapoff` disables swap on the specified disk. 
