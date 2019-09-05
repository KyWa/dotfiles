# Ansible

Ansible has two types of machines in its architecture: control nodes and managed hosts. Ansible is run from a control node. A control node could be an admins laptop or Ansible Tower (AWX). A managed hosts are listed in an inventory which also organizes those systems into groups. The inventory can be defined in a static text file or dynamically determined by scripts that get information from external sources.

Ansible users create hihg-level *plays* to ensure a group of hosts are in a particular state. A lpay performs a series of *tasks* on the hosts in the order specified by the play. These plays are written in YAML. A file that contains one or more plays is called a *playbook*. Each task runs a *module*, a small piece of code (written in Python, Powershell, or some other language) with specific arguments. Tasks, plays, and playbooks are designed to be idempotent.

* [Conditionals](Ansible/Conditionals)

# Misc Notes

`handler`'s work if they are called by a `notify` inside a task. `notify` will only call if a change is made during its run.

Inventory files can use env variables like so:

```
[example]
10.0.0.1 ansible_user="{{ lookup( 'env', 'USERNAME') }}"

[all:vars]
var="{{ lookup( 'env', 'HOME') }}"
```

HostVars: `"{{ hostvars['web1']['ansible_facts'] }}"`

#### Debug

Create a task called `debug:` and give it an option for `msg:` to print out to the play result what you need. Could be facts, could be results of something else.


## Vault

Older versions of Ansible use `--ask-vault-pass` to allow interactivity for Ansible ask the vault password. Post Ansible 2.4 the new method is to run playbooks needing vault secrets like so: `ansible-playbook --vault-id @prompt playbook.yml`

You can use the --vault-password-file option to specify a file that stores the encryption password in plain text. The password should be a string stored as a single line in the file. `ansible-playbook --vault-password-file=vault-pw-file playbook.yml`

## Facts

Facts can be checked with calling their variables in various wasy: `ansible_facts['hostname']` or `ansible_facts.hostname`.
