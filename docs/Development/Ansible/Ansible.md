# Ansible

Ansible has two types of machines in its architecture: control nodes and managed hosts. Ansible is run from a control node. A control node could be an admins laptop or Ansible Tower (AWX). A managed hosts are listed in an inventory which also organizes those systems into groups. The inventory can be defined in a static text file or dynamically determined by scripts that get information from external sources.

Ansible users create hihg-level *plays* to ensure a group of hosts are in a particular state. A lpay performs a series of *tasks* on the hosts in the order specified by the play. These plays are written in YAML. A file that contains one or more plays is called a *playbook*. Each task runs a *module*, a small piece of code (written in Python, Powershell, or some other language) with specific arguments. Tasks, plays, and playbooks are designed to be idempotent.

* [Conditionals](Conditionals)
* [Inventories, Hosts and Groups](Inventories)
* [Facts and Variables](FactsAndVars)
* [Playbooks](Playbooks)
* [Tower](Tower)


#### Debug

Create a task called `debug:` and give it an option for `msg:` to print out to the play result what you need. Could be facts, could be results of something else.

## Configuration

The default config file is located at `/etc/ansible/ansible.cfg` and will be used if no other config file exists.
Ansible will look for a config file located at `~/.ansible.cfg` and will take precedence over the default config file unless there is an `ansible.cfg` file located in the directory from where Ansible is run.

Configuration variables can be set in the config files as shown below:

```
[defaults]
remote_user = ansibleuser
ask_pass = false

[privilege_escalation]
become = true
become_user = root
```

Custom modules can be used by adding their location in the ansible.cfg files via `library = /usr/share/my_modules`. They are also searched for in the value of the environment variable `ANSIBLE_LIBRARY`.

## Vault

Older versions of Ansible use `--ask-vault-pass` to allow interactivity for Ansible ask the vault password. Post Ansible 2.4 the new method is to run playbooks needing vault secrets like so: `ansible-playbook --vault-id @prompt playbook.yml`

You can use the --vault-password-file option to specify a file that stores the encryption password in plain text. The password should be a string stored as a single line in the file. `ansible-playbook --vault-password-file=vault-pw-file playbook.yml`

### For AAP/AWX/Tower

`ansible-vault encrypt_string --vault-password-file ~/.vault-pass 'admin@internal' --name ovirt_username`

This will print out something like:

```sh
ovirt_username: !vault |
AESVAULLJWADJA)J)(
```

Tower cannot parse encrypted files when it syncs the inventory, but it can read files that have encrypted values. It will take a Vault credential at runtime to decrypt the secret values. Somewhat of an annoyance, but not a big change unless your environment has hundreds of encrypted files vs encrypted strings in a file.

Dir structure after changes

```
inventory
- group_vars
- - all
- - - vault
- - - - secrets.yaml # A plain text file with encrypted values like above
```

## Useful Jinja2 Things

```
# The main focus of this is the if not loop.last section which will only do something if its not the last item in the loop (for things like comma separated values)
{
  "auths": {
{% for item in SOME_VAR.results %}
    "{{ REGISTRY_HOSTNAME }}/{{ item.item }}": {
      "username": "{{ item.name }}",
      "password": "{{ item.token }}",
      "auth": "{{ (item.name + ':' + item.token) | b64encode }}",
      "email": ""
{%- if not loop.last %}
    },
{% else %}
    }
{% endif %}
{% endfor %}
  }
}
```

# Misc Notes

`handler`'s work if they are called by a `notify` inside a task. `notify` will only call if a change is made during its run.

Inventory files can use env variables like so:

```
[example]
10.0.0.1 ansible_user="{{ lookup( 'env', 'USERNAME') }}"

[all:vars]
var="{{ lookup( 'env', 'HOME') }}"
```

* `rescue` - Defines the tasks to run if the tasks defined in the block clause fail.
* `always` - Defines the tasks that will always run independently of the success or failure of tasks defined in the block and rescue clauses.

You cannot use `{{ inventory_dir }}` if targeting localhost as your host gorup.

