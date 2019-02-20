#Deploy, Configure and Maintain Systems

##Configure network Hostname Resolution Statically or Dynamically: Troubleshooting

`ifconfig` is being depricated. `ip` is the new program to use. Syntax is similar:

* `ip addr` - shows all NIC addresses (just use `ip a` for short)
* `ip addr show <NIC>` - shows info for a single NIC
* `ip -s link show <NIC>` - shows transmit information for a given NIC

`netstat` is being depricated. `ss` is the new program to use. `ss` allows us to look at listening ports and established connections. 

* `-a` - show all listening ports/connections
* `-t` - shows only TCP
* `-u` - shows only UDP
* `-n` - shows port number instead of "service"

##Configure network Hostname Resolution Statically or Dynamically: Network Manager

`nmcli` is Network Manager's cli tool. `nmtui` is Network Manager's TUI tool. 

##Configure network Hostname Resolution Statically or Dynamically: Hostname Configuration

`/etc/resolv.conf` has a `search` line which adds a search suffix to queries. `nameserver` specifies which DNS nameservers to use when resolving DNS names. `/etc/hosts` can be used to "poison" DNS entries by overruling DNS queries with hard coded entries. `/etc/resolv.conf` is modified/managed by Network Manager. `/etc/nsswitch.conf` is a config file that manages Name Service Switching. Inside of here you can specify to use `files` when doing host lookups or remove it so the `/etc/hosts` file cannot be used to override/poison DNS queries.

`hostname` will return the current hostname or allow you to temporarily change the local hostname. `hostnamectl` permanently changes the local hostname. `hostname status` can be used to show more information about our host and its hostname.

To change the DNS server for an interface without editing /etc/resolv.conf (which will be overwritten if using NetworkManager), you can use `nmcli` to update accordingly:

* `nmcli con mod "<system nic>" ipv4.dns <new DNS IP>`

`getent` can be used to get entries from Name Service Switch libraries.

##Schedule Tasks Using at and cron

*at*

`at` is simliar to cron as it handles tasks "at" a certain/set time. Not installed by default. `atq` will list all jobs set to run. `atrm` will remove an `at` job. If the file `/etc/at.allow` exists only the users in the file can use `at`. If the file `/etc/at.deny` exists, all users can use `at` except those in the file `/etc/at.deny`. Only one of these files can exist and still function.

###Common commands

* `at now +1 minute` - runs whatever command 1 minute from issuing this command
* `at 12:00am` - runs whatever command at midnight

*cron*

`cron` is installed by default on all Linux systems. `cron` has preconfigured directories to place scripts in to have them done hourly,daily,weekly, and monthly. The file `/etc/crontab` shows a layout of how the timing works. A single example is below which will run the script `/usr/bin/logger hi` every 5 minutes every day:

`*/5 * * * * root /usr/bin/logger hi`

##Configure a Physical Machine to Host Virtual Machines

Required packages to install/memorize to have a fully running virtualized environment in RHEL 7:

* virt-manager
* qemu-kvm qemu-img
* libvirt
* libvirt-python
* python-virtinst
* libvirt-client

`libvirtd` must be enabled and started. 

##Configure a System to use Time Services

`timedatectl` is the main tool used to set time on a RHEL based Linux system. `tzselect` will give an interactive shell to find the zone information needed to set the correct time. 

###common options for timedatectl

* `timedatectl set-time 12:32`
* `timedatectl set-timezone Americas/Chicago`

*ntp*

For `ntp`, `chronyd` is the daemon that handles `ntp` services. `chronyc` is a CLI tool to manage `chronyd`.

##Insatlling and Updating Software Packages with YUM

`yum` stands for YellowDog Update Manager. `yum check-update` will pull package information and check which packages have update candidates. `rpm` is the underlying package management system of `yum`. `yumdownloader` can be used to download the rpm package without installing it. `yum localinstall` will install a .rpm file instead of using the `rpm` command. 

`rpm` is a program which can create,install,remove and upgrade software packages for deployment on a RHEL based system.  `rpm -ql` will list all files that were installed as part of the specified package. `rpm -qd` will list all documentation files associated with the specified package.

With `yum` there are package groups that can be installed via `yum groupinstall`. Information can be obtained about these groups by doing a `yum group info <package>`. This will return all the packages with some symbols next to them. 

* `-` - Package is not installed and will not be installed as part of the group
* `+` - Package is not installed but will be on the next `yum upgrade`
* `=` - Package is installed and it was installed as part of the package group
* `no symbol` - Package is installed but was outside the package group
