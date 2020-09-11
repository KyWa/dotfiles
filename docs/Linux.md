# Linux Stuff

## tmux

Main control combo: `ctrl+b`. combo+command

### Commands
* `c` create new window
* `n` go to next window
* `p` go to previous window
* `,` rename window
* `%` split window vertically
* `"` split window horizontally
* `:` type command

### boot into single user

Edit the kernel line and add the following to the end: `rd.break`

### change root password while in single user

Once the shell comes up remount the filesystem to allow for writes: `mount -o remount,rw /sysroot`

Chroot into /sysroot

Change the password with `passwd`

Add the autorelabel file for SELinux: `touch /.autorelabel`

Exit the shell to reboot the system


### change current runlevel

`systemctl isolate <runevel.target>`

### change default

`systemctl set-default <runlevel.target>`

### targets

* runlevel1.target --singleuser
* runlevel3.target --multi-user w/o graphics
* runlevel5.target --multi-user w/ graphics


### Check Age of passwd for user
`chage -l username`
### Set passwd to never expire
`chage -I -1 -m 0 -M 99999 -E -1 username`
### Reset user account login attempts
`pam_tally2 --user=USER --reset`


### Adding Storage to live machine
#### SAN add guest of physical - run these in order to get an ioscan equivelant
`for h in /sys/class/scsi_host/host?; do echo $h; echo - - - > $h/scan; done`

`for d in /sys/block/sd*/device/rescan; do echo 1 > $d; done`

#### Find all hard links to a file
`find . -samefile /path/to/file` 

#### Issues with SSH keys w/ SELINUX
`restorecon -R -v ~/.ssh`

#### SMB/CIFS testing
`smbclient -L <fileshare hostname> -A <authfile>`

Authfile should be look like this:

domain = DOM.LOC
username = <username>

#### `find` all dead symlinks and remove
`find -L . -name . -o -type d -prune -o -type l -exec rm {} +`

#### Interactive Shell vs Non-Interactive SHell

`/etc/profile` and `~/.bash_profile` are used for interactive shells. AKA being logged into the terminal/shell and using it. `/etc/bashrc` and `~/.bashrc` are used for both and only for non-interactive (shell scripts, one off ssh commands etc..).

### `jq`
`jq -r ".itme.'nested.item'"`

For nested items that contain `.` in their field must put items in quotes as seen above.

### Quickly get system IP
`hostname -I | awk '{print $1}'` gets ip in clean format of machine

#### Remove single line from crontab
`crontab -u root -l | grep -v 'command in cron' | crontab -u root -`

#### Get which thread a process is running on
`for i in $(pgrep process);do ps -mo pid,tid,fname,user,psr -p $i;done`

#### Get heavy hitting processes
`ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10`

#### Get System Age
`tune2fs -l /dev/sda1 | grep created`

#### Find local dirs taking up space
`du -x -h --max-depth=1 /`

#### Putty Terminal output issues
`export NCURSES_NO_UTF8_ACS=1`

#### Timestaps in History
`export NCURSES_NO_UTF8_ACS=1`
`HISTTIMEFORMAT="%d/%m/%y %T "`

#### Centos Regnerate initramfs for Hyper-V if coming from other platform
`mkinitrd -f -v --with=hid-hyperv --with=hv_utils --with=hv_vmbus --with=hv_storvsc --with=hv_netvsc /boot/initramfs-$(uname -r).img $(uname -r)`

#### Iterate over 2 ranges
`n=1`
`for i in {01..99};do mv $i $n;n=$(($n+1));done`

#### VIM append/insert
Highlight the lines you want with visual block mode `V` and then hit `:` and `:'<,'>` will be in command for you. Add whatever you are needing to this. Example: `:'<,'>s!^!*\ ` will add `* ` to the beginning of each highlighted line. Note there is a space after the `\` here.

### KVM
With a bridge interface, to get traffic through the firewall (replace bridge0 with actual bridge name): `firewall-cmd --permanent --direct --passthrough ipv4 -I FORWARD -i bridge0 -j ACCEPT`

### HTPasswd
Create/Update a user password using htpassword auth
`htpasswd /etc/origin/master/htpasswd username`
