=misc=

==tmux==

Main control combo: `ctrl+b`. combo+command

# Commands
* `c` create new window
* `n` go to next window
* `p` go to previous window
* `,` rename window
* `%` split window vertically
* `"` split window horizontally
* `:` type command

==Booting and Runlevels==
*boot into single user*

Edit the kernel line and remove `ro` and replace with:
`rw init=/sysroot/bin/sh`

*change root password while in single user*

Once the shell comes up remount the filesystem to allow for writes: `mount -o remount,rw /sysroot`

Change the password with `passwd`

Add the autorelabel file for SELinux: `touch /.autorelabel`

Exit the shell to reboot the system

*change current runlevel*

`systemctl isolate <runevel.target>`

*change default*

`systemctl set-default <runlevel.target>`

*targets*

* runlevel1.target --singleuser
* runlevel3.target --multi-user w/o graphics
* runlevel5.target --multi-user w/ graphics


* Find LDAP groups on server
`ldapsearch -x -LLL -h $(grep uri /etc/ldap.conf | cut -f3 -d/ | tr -d ' ') -b ou=Groups,o=hp.com (|(cn=host-$(hostname))) | grep member`

* Check Age of passwd for user
`chage -l username`
* Set passwd to never expire
`chage -I -1 -m 0 -M 99999 -E -1 username`

* Reset user account login attempts
`pam_tally2 --user=USER --reset`

---
#Figure out what network a particular interface is on (if non-standard setup)
Bring the NIC up without an IP address (This will only work if it has link and a base cfg file)

`ifcfg ethX up`

Give it a few seconds to init. Then run ethtool on the interface to make sure it has link:

`ethtool ethX | grep -i link`

If you have link (Link: yes) then run this to check for traffic on that NIC:

`tcpdump -i ethX`

This will basically sniff traffic on the network. Look for hostnames as they fly by. This will tell you what network you are on. 
Then just cross reference the hostname and its resolving IP to find out what VLAN/Network its on.
---

* SAN add guest of physical - run these in order to get an ioscan equivelant
`for h in /sys/class/scsi_host/host?; do echo $h; echo - - - > $h/scan; done`

`for d in /sys/block/sd*/device/rescan; do echo 1 > $d; done`

* Find all hard links to a file
`find . -samefile /path/to/file` 

* Issues with SSH keys w/ SELINUX
`restorecon -R -v ~/.ssh`

* SMB/CIFS testing
`smbclient -L <fileshare hostname> -A <authfile>`

Authfile should be look like this:

domain = DOM.LOC
username = <username>

* Interactive Shell vs Non-Interactive SHell

`/etc/profile` and `~/.bash_profile` are used for interactive shells. AKA being logged into the terminal/shell and using it. `/etc/bashrc` and `~/.bashrc` are used for both and only for non-interactive (shell scripts, one off ssh commands etc..).
