# misc

## tmux
---
Main control combo: `ctrl+b`. combo+command

*Commands*
* `c` create new window
* `n` go to next window
* `p` go to previous window
* `,` rename window
* `%` split window vertically
* `"` split window horizontally
* `:` type command
---

## Booting and Runlevels
---
*boot into single user*

Edit the kernel line and add the following to the end: `rd.break`

*change root password while in single user*

Once the shell comes up remount the filesystem to allow for writes: `mount -o remount,rw /sysroot`

Chroot into /sysroot

Change the password with `passwd`

Add the autorelabel file for SELinux: `touch /.autorelabel`

Exit the shell to reboot the system
---
*change current runlevel*

`systemctl isolate <runevel.target>`

*change default*

`systemctl set-default <runlevel.target>`

*targets*

* runlevel1.target --singleuser
* runlevel3.target --multi-user w/o graphics
* runlevel5.target --multi-user w/ graphics
---

* Check Age of passwd for user
`chage -l username`
* Set passwd to never expire
`chage -I -1 -m 0 -M 99999 -E -1 username`

* Reset user account login attempts
`pam_tally2 --user=USER --reset`

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

* `find` all dead symlinks and remove
`find -L . -name . -o -type d -prune -o -type l -exec rm {} +`

### Interactive Shell vs Non-Interactive SHell

`/etc/profile` and `~/.bash_profile` are used for interactive shells. AKA being logged into the terminal/shell and using it. `/etc/bashrc` and `~/.bashrc` are used for both and only for non-interactive (shell scripts, one off ssh commands etc..).

### `jq`

`jq ".[] | { domainname: .name, nameservers: .nameServers[0]}"`

This will return the .name string and the .nameServers string and put them on seperate
