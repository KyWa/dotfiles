# Ansible Inventories, Hosts and Groups

To see what all hosts are in a group you can run: `ansible <group> --list-hosts`

## Inventories
By default `/etc/ansible/hosts` is the default inventory file unless specified otherwise.

## Hosts

## Groups

Groups are made up of hosts. You can also have groups made up of other groups (nesting). Create a new group and add `:children` to the end of its name:

```
[usa:children]
texas
colorado

[texas]
host1.example.com

[colorado]
host2.example.com
```
