#Manage Security

`netfilter` is the part of the kernel that manages packet filtering.

##Key-Based Authentication for SSH

The public key is used to verify the private key. Private keys must be protected and stored securely. To generate ssh-keys you use the program `ssh-keygen`. `rsa` and `dsa` are both strongly encrypted. Default storage for ssh-keys store themselves in `/home/<user>/.ssh/(id_rsa and id_rsa.pub)`. The directory `.ssh` must be secured and requires 700 permissions or ssh authentication will not work. `id_rsa` requires 600 to function properly. To push the public key to a remote server you can use the `ssh-copy-id` command to authenicate over ssh and copy the `id_rsa.pub` key to the remote server.

`ssh-agent bash` and then `ssh-add` will add a cache of your passphrase for your ssh-keys for your current session. 

##Intro to SELinux

SELinux is an application firewall for written by the NSA for Linux systems. All files/folders/processes/ports have an SELinux context. This determines if that object has rights to alter other objects on the system. `getenforce` shows the current run-mode and `setenforce` will set the current run-mode. `/etc/selinux/config` is the main configuration file for `selinux` to set which run-mode it lives in. A reboot is required to force the new mode.

###SELinux Documentation and man pages:

* `booleans`
* `selinux`
* `getsebool`

To view the SELinux context of a file do an `ls -Z` and the column after group ownership shows the context for the objects. `semanage fcontext -l` will list all the available contexts on the system and files they are associated with. You can also see which context a given process is operating under by adding a `Z` to your `ps` command query. 

If a file has improper context either because of it being copied from a different directory or any other reason, you can relabel a single file by running the commande: `restorecon /path/to/file`. SELinux has a default schema for when a system is initially created. Sometimes due to user error this can get skewed. To force SELinux to automatically relabel all files in the system all you need to do is create a file in the root directory called `.autorelabel` like so: `touch /.autorelabel`. Once the system is rebooted, SELinux will relabel all files on the system to be set back to their default state of context as they should be based on the default SELinux configuration.

To create a new context for a directory you will use `semanage` to do that. Some examples below:

* `semanage fcontext -a -t httpd_sys_content_t '/path/to/web(/.*)?'` - This will allow `httpd` to read and access this file once this has been applied with `restorecon`
* `semanage fcontext -d "/path/to/web(/.*)?"` - This will delete the rule created previously and a `restorecon` will need to be run again

SELinux booleans enable runtime customization of SELinux policy.

`getsebool` will get a list of all SELinux Booleans and their values (current, default). `setsebool` will change the current run-mode of a specific SELinux boolean as it stands and adding a `-P` will make it persist through reboots.

###Diagnosing and Addressing SELinux policy violations

`setroubleshoot-server` isn't preinstalled by default. It is a tool which will allow you to run `sealert` on the audit log (`/var/log/audit/audit.log`) and view the log in a human readable format with options showing what failed in SELinux and how to resolve it. `-a` flag should be used to run reports in the default setting.
