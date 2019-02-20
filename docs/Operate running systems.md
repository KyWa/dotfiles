#Operating Running Systems

##reboot,shutdown

`/usr/bin/shutdown` can be passed with a few flags. Needs either `-r` or `-h`. If run with no flags it will initiate a reboot one minute from pressing return.

* `-r` reboot
* `-h` halt
* `-c` cancel any previous shutdown issued
* `now` shutdown now
* `+#` shutdown in `#` minutes
* `00:00` shutdown at specificed time (24hr format)

##booting systems into different runlevels

To find the default runlevel run `systemctl get-default`. To change 'runlevel' you run `systemctl isolate <runlevel type>.target`.

###Runlevel Targets

* `multi-user` all services running, no GUI
* `graphical` all services running, with GUI
* `rescue` rescue mode  (single usermode)

Any unit files in `/etc/` will overrule anything in `/usr/lib/systemd/system`. Systemd based systems need a `default.target` file in `/etc/systemd/system` in order to boot properly.

In the grub menu on bootup, you can specify the runlevel to boot into by appending `systemd.unit=<runlevel type>.target` and booting.

##Process Management

`pgrep` is capable of searching for processes with the name passed. `pgrep` defaults to showing just the PID, pass `-l` to see the name of the process. `-u` and giving a user name will show all processes for that user.

`pkill` can kill the found proceses. `ps` is used to search for processes. `pkill` uses the standard POSIX `kill` codes (-9, -15, etc..).

##Locate and Inerpret System Log Files/Journals

`rsyslog` is the actual mechanism doing logging to the journal and system. Config file for `rsyslog` can be found in `/etc/rsyslog.conf`. `journalctl` dumps all data to stdout (via less) from current journal. Data is not consistent. Data is stored in `/run/log/journal/`. In `/etc/systemd/journald.conf` you can change the persistence of the journal. Any system event is put into the journal. 

* `-n` last 10 lines
* `-x` provide extra details
* `-f` equivelant of -f (follow)
* `_SYSTEM_UNIT=<unitname>` shows journal for that specific unit/service/socket
* `--since=<day,yesterday,etc..>` shows journal since timeframe specified

For bootup information `systemd-analyze` can be run to find startup times in each portion of the boot (kernel,initrd,userspace). `systemd-analyze blame` will show each process and its time to complete during boot.

##Start, Stop and check the status of Network Services

Find network services via `systemctl list-units | grep -i network`. To ensure service starts at boot time it must be enabled `systemctl enable <service>`. You can specify a `start`/`stop`/`restart` by replacing `enable` with any of the previous 3. If changes were made to a services configuration file (changing a parameter or something of the sort) you can reload the configuration instead of stopping or starting the service by using `reload` instead of the previous options for a given service.

##Securely Transfer Files between Systems

`scp` and `sftp` use port 22 to transfer files. Both are secure as they use ssh and related keys to encrypt the traffic. `scp` examples below:

* `scp file1 10.0.0.2:file1` transfers file1 *from the local* directory to the remote server
* `scp 10.0.0.2:file1 file1` transfers file1 *from the remote* server to the local directory
