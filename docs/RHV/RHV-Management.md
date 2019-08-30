# RHV Management

Self-Hosted engine runs on a single node. Currently no knowledge of making HA (outside of failover).

Cluster has migration management settings. The cluster can be configured to have auto migration of VMs (if load is to high in a single host) and load balance the VMs across the cluster. These settings can be found in Compute > Cluster EDIT > Migration Policy/Scheduling Policy. 

To wipe a RHV-M environment, from the RHV-M server run: `engine-cleanup`.

On each of the hosts running RHV, you can run a few sanity checks. One of these is `nodectl check`. This will output information on its bootloader, mountpoints, its storage and the status of the `vdsmd` daemon. 

On the RHV-M machine, to alter configuration, you can use the `engine-config -a` and look for settings to alter. Then you can run `engine-config -s Parameter=NewValue`. For example, a default check for waiting for a host to reboot before checking to bring it back in is defauled to 5 minutes. This can be changed by running `engine-config -s ServerRebootTimeout=60` will set it to 1 minute. Then update the running configuration with `systemctl restart ovirt-engine` (there is no reload option for this service).

## Updating and Upgrading RHV-M

### Distinguishing Between Updates and Upgrades

In this context, that means updates between different releases of Red Hat Virtualization 4.3, for example from 4.3.4 to 4.3.7.

When the documentation discusses upgrades between "major releases," it generally considers an update from 4.2 to 4.3 as a "major" release. This is because changes between those versions may involve updating cluster and data center compatibility versions, and may add or change features, among other things.

To see if there is an upgrade available for the RHV-M, run `engine-upgrade-check`.

Run `yum update ovirt\*setup\*` to update the setup packages. If an upgrade/update takes place, run `engine-setup` without arguments. This will will update the RHV-M and stops it while it downloads the packages and updates them. During this process, it also creates a backup of the database, performs the update of the database, applies post-installation configuration, and starts the ovirt-engine service.

## Backup and Restore of RHV-M

### Backing Up

It is important to maintain complete backups of the machine running Red Hat Virtualization Manager, especially when making changes to the configuration of that machine. As part of a backup strategy, the engine-backup utility can be used to back up the RHV-M database and configuration files into a single archive file that can be easily stored.

    ### WARNING
    The engine-backup command only backs up key configuration files, the engine database, and the Data Warehouse database of your RHV-M installation. It does not back up the operating system or installed software. The restore process requires that the RHV-M server has been reinstalled with an operating system and the RHV-M software packages, but that engine-setup has not yet been run.
    
`engine-backup` can be run with a few options:

* `--mode=mode` - Backup or restore are the modes. This option is required.
* `--file=backupfile` - Specifies the location of the archive file containing the backup. This option is required.
* `--log=log-file` - Specifies the location of a file used to record log messages from the backup or restore operation. This option is required.
* `--scope=scope` - Specifies the scope of the backup or restore operation. There are four scopes:
    * `all` - backup or restore the engine database, Data Warehouse, and RHV-M configuration files (this is the default option).
    * `db` - backup or restore only the engine database.
    * `files` - backup or restore only RHV-M configuration files.
    * `dwhdb` - backup or restore only the Data Warehouse database.

    ### NOTE 
    You can run `engine-backup` while RHV-M is running.

When using engine-backup to restore the database from a backup, there are options that may needed:

* `--provision-db` - Creates a PostgreSQL database for the RHV-M engine on the server being restored. Used when restoring to a fresh installation that has not been setup.
* `--provision-dwh-db` - Creates a database for the Data Warehouse on the server being restored. Used when restoring to a fresh installation that has not been setup.
* `--restore-permissions` - Restores database permissions stored in the backup. Used when restoring to a fresh installation, or when overwriting an installation that was previously set up.

By using the engine-backup with `--mode=backup` option, you will create a `.tgz` (TAR Archive file). The file can be created in a directory using the `--file` option. The tar file contains a backup of RHV-M configuration files, the engine database, and the Data Warehouse database. This backup archive should be copied from the RHV-M server to secure storage for later use.

### Restoring

While the process for restoring a backup using the engine-backup command is straightforward, there are several additional steps when compared to the process for creating a backup. The steps required depend on the destination to which the backup will be restored. For example, the engine-backup command can be used to restore backups to fresh installations of Red Hat Virtualization, on top of existing installations of Red Hat Virtualization, and using local or remote databases.

    ### WARNING
    Backups can only be restored to environments of the same major release as the backup. For example, a backup of a Red Hat Virtualization version 4.1 environment can only be restored to another Red Hat Virtualization version 4.1 environment. To view the version of Red Hat Virtualization contained in a backup file, administrators can unpack the backup file and read the value in the `version` file, located in the root directory of the unpacked files.
    
A full restore command would look like this: `engine-backup --mode=restore --file=backup-file.tgz --log=log-file --provision-db --provision-dwh-db --restore-permissions`

    ### NOTE
    Any objects that were added AFTER a backup was completed (vms, disks, etc...) are missing in the engine and will probably require recovery or recreation
    
After restoring a RHV-M instance run `engine-setup --accept-defaults --offline` to ensure that the restore goes live.
    
### Overwriting a RHV-M Installation

If you have made environment changes to the RHV-M installation since the last backup, you can discard those changes by running an engine-cleanup command. The engine-cleanup prompts for removal of components, stopping the engine service, and removing all installed ovirt data. If you do not want to remove the data, then engine-cleanup will abort.

After cleaning the RHV-M setup from the host server, you can then run the engine-backup command to restore a full backup, or a database only backup. The tables and credentials are already created, so you do not need to create new ones.

You can omit specific databases by leaving out the --scope="database" option when running the engine-backup command. After restoring the database, you must run the engine-setup command again to reconfigure the RHV-M.
