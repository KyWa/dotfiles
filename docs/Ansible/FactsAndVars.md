# Ansible Facts and Variables


## Facts

Facts can be checked with calling them in various ways: `ansible_facts['hostname']` or `ansible_facts.hostname`. Or the whole list of facts can be printed with a `debug` module: 

```yaml
### Output is in JSON
debug: 
  var: ansible_facts
```

Ansible facts are variables that are automatically discovered by Ansible on a managed host. Facts contain host-specific information that can be used just like regular variables in plays, conditionals, loops, or any other statement that depends on a value collected from a managed host.

To be able to see and or use facts, you must not disable fact gathering!!! (`gather_facts: false` helps no one)

### Custom Facts

On each managed host a directory can be created that will be pulled in with the setup module. The facts files must end in .fact and be located in `/etc/ansible/facts.d/`. It follows a similar INI style to an inventory file and reads like this:

```ini
[packages]
web_package = httpd
db_package = mariadb-server

[users]
user1 = joe
user2 = jane
```

This data could also be stored in a JSON format:

```json
{
  "packages": {
    "web_package": "httpd",
    "db_package": "mariadb-server"
  },
  "users": {
    "user1": "joe",
    "user2": "jane"
  }
}
```

These custom facts can be used in a similar way to default facts: `{{ ansible_facts.ansible_local.custom.packages.web_package }}`

## Variables

Essentially 3 levels of scope come into play with Variables. Global, Play and Host are what they boil down to. Precedence is key with variables and takes a top down approach. Something passed in via `-e myvar=var` will overwrite a host_var called `myvar`.

### Declaring Variables

Vars can be added in playbooks like so:

```yaml
---
- hosts: all
  vars:
    user: kyle
    home: /home/kyle
```

A vars file can also be used (external to the playbook):

```yaml
---
- hosts: all 
  vars_files:
    - vars/users.yaml
```

The resulting file can have vars built out in normal YAML format (K/V):

```yaml
user: kyle
home: /home/kyle
```

### Using vars in playbooks

Variables can be called in playbooks by putting the variable name inside a set of curly braces like so:

```yaml
vars:
  user: kyle
  
tasks:
  - name: create a user using a variable
    user:
      name: "{{ user }}"
```

One key thing to note when putting variables in quotes. If a variable is being used as the first element to start a value, quotes are mandatory. This prevents Ansible from interpreting the variablreference as starting a YAML dictionary.


### Host and Group Variables

Host vars are just what they sound like, variables that are applied to a single host, whereas group vars are applied to all hosts in a group(s). The format is slightly different with normal inventory files which use the INI format.

```ini
# Defining vars for a single host
[servers]
demo.example.com myvar=var
```

```ini
# Defining vars for a group
[servers]
demo1.example.com
demo2.example.com

[servers:vars]
myvar=var
```

```ini
# Defining vars for groups of host groups
[servers1]
demo1.example.com
demo2.example.com

[servers2]
demo3.example.com
demo4.example.com

[servers:children]
servers1
servers2

[servers:vars]
myvar=var
```

The preferred and recommened method is defining variables for hosts and groups in directories (`host_vars` and `group_vars`) in the working directory of the inevntory file. Using this method continues using YAML syntax. The files are placed in a way such as this: `~/project/inventory/group_vars/servers/vars.yml` or `~/projects/inventory/group_vars/servers.yaml`. You can create a directory with the group name and all YAML files in that directory will be applied regardless of name (so long as its a .yaml/.yml). Or you can create a file with the name of the group and put variables in there (also ending in .yaml/.yml).

### Variables and Arrays

Variables can be written to an array. Below is an example of configuration data that is written out with multiple variables and then the same data written as an array.

```yaml
user1_first_name: Bob
user1_last_name: Jones
user1_home_dir: /users/bjones
user2_first_name: Anne
user2_last_name: Cook
user2_home_dir: /users/acook
```

```yaml
users:
  bjones:
    first_name: Bob
    last_name: Jones
    home_dir: /users/bjones
  acook:
    first_name: Anne
    last_name: Cook
    home_dir: /users/acook
```

This data can be accessed using variable calls like this: `users.bjones.first_name` or `users.acook.home_dir`. Because this data is defined as a Python dictionary an alternative syntax could be used: `users['bjone']['first_name']` or `users['acook']['home_dir']`

	## NOTE
	The dot notation can cause problems if the key names are the same as names of Python methods or attributes, such as discard, copy, add, and so on. Using the brackets notation can help avoid conflicts and errors.

### Registering Variables

You can use the `register` statement to capture the output of a command. It is then saved into a variable that can be used later. Example of `register` usage:

```yaml
---
- name:  Install a package and print results
  hosts: all
  tasks:
    - name: Install the package
	  yum:
		name: httpd
		state: installed
      register: install_result

	- debug: var=install_result
```

### Magic Variables

Some variables are not facts or configured through the setup module, but are also automatically set by Ansible. THese magic variables can also be useful to get information specific to a particular managed host. Four of the most useful are:

* `hostvars`: Contains the variables for managed hosts and can be used to get the values for another managed host's variables. It does not include the managed hosts facts if they have not yet been gathered for that host.
* `group_names`: Lists all groups the current managed host is in.
* `groups`: Lists all groups and hosts in the inventory
* `inventory_hostname`: Contains the host name for the current managed host as configured in the inventory. This may be different from the host name reported by facts for various reasons.
