# Create, Mount, Unmount and use VFAT,EXT4, and XFS File Systems

### ext based plus fat/vfat

`mkfs` is used to `M`a`k`e a `F`ile `S`ystem on an existing partition/disk. It is called as per the filesystem you wish to use. Example:

* `mkfs.ext4 /dev/sda2` - This will make an `ext4` filesystem on the device `sda2`

The `mount` command is used to temporarily mount a filesystem (local or remote) into the system. This will not survive a reboot however and the `fstab` should be used for persistence. `umount` is used to unmount filesystems. In certain scenarios the `-l` flag should be used if a filesystem is hung (nfs server dies or the like). Examples:

* `mount -t ext4 /dev/sda2 /mnt`
* `umount /dev/sda2`

`fsck` cannot be run against a mounted file system. This is why in the `fstab` we have the final column which tells the system on boot when to run a `fsck` on the filesystems. Because of the way POSIX systems have an initramfs the actual file system isn't mounted until after this process, thus allowing the would be unmountable filesystems to have an `fsck` run on them on bootup. `fsck` will figure out the filesystem its targeted against and use the correct check.  

* `fsck /dev/sda2` vs `fsck.ext4 /dev/sda2` - It knows what it needs to use

To get highly detailed information about a filesystem such as the ext based filesystems the program dumpe2fs can be used. 

### xfs based

For the equivelant of `dumpe2fs` for `xfs` filesystems, you will use `xfs_info`. `xfs_admin` will allow you to do labeling and checking. For `fsck` equivelant use `xfs_repair` instead.

## Mount and Unmount NFS/CIFS filesystems

Network shares are mounted via the `fstab` and the `mount` command just like a local file system. When mounting with the `mount` command you must specify the `-t` flag and specify the filesystem type `nfs` or `cifs`. Examples below:

* `mount -t cifs //<IP or Hostname>/ShareName -o options,comma,seperated`
* `mount -t nfs <IP or Hostname>:SharePath -o options,comma,seperated`

For the `fstab` similarly to a local device. Never dump or `fsck` a remote file system as its the job of the fileserver to verify the integrity

* CIFS - `//<IP or Hostname>/Sharename /mount/location cifs <options or defaults> 0 0`
* NFS - `<IP or Hostname>:path/to/share /mount/location cifs <options or defaults> 0 0`

## Extend Existing Logical Volumes

For Logical Volume Management there are a few things to know when it comes time to grow the volumes. To grow the logical volume you use `lvextend`. There are a few things to be aware of when extending the logical volume. Examples:

* `lvextend -L 5G /dev/vg00/lvol00` - This will extend the Logical Volume lvol00 *TO* 5GB
* `lvextend -L +5G /dev/vg00/lvol00` - This will extend the Logical Volume lvol00 *BY* 5GB
* `lvextend -l +100%FREE /dev/vg00/lvol00` - This will extend the Logical Volume lvol00 *BY* all the remaining space left on the Volume Group vg00

Once the underlying volume (or disk in a virtual environment) is extended, the actual filesystem needs to be increased otherwise the space will not be available. Depending on the filesystem type depends on which tool is used. For EXT based filesystems you will use `resize2fs /path/to/device`. For XFS filesystems you will use `xfs_growfs`.

## Create and Configure Set-GID Directories

Using `chmod g+s <group_name>` will change the use the Set-GID on the directory you specify to cause any files/folders created inside of it to take the parent directory's group. Example:

* `chmod g+s infra dir1` - This will have change the group sticky bit for dir1 to become infra. This will force any file/dir created inside of dir1 to have the owner of infra.

## Create and Manage Access Control Lists

By default `xfs` supports ACL, this means nothing needs to be mounted or flagged a specific way (`ext4` must be mounted with the `acl` flag). The command `setfacl` or "set file access control lists" has a few options which will be listed below. `getfacl` will get the file access control lists. 

* `-m` - Modify or Set
* `u:<user>:<perms>` - Permissions to apply to user
* `g:<group>:<perms>` - Permission to apply to group
* `-d` - Default Settings
