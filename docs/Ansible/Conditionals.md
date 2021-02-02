# Ansible Conditionals

## Changed

By default, when a task makes a change to a managed host, it reports the `changed` state and notifies handlers. When a task does not need to make a change, it reports `ok` and does not notify handlers.

The `changed_when` keyword can be used to control when a task reports that it has changed. For example, the `shell` module in the below example is used to get Kerberos crednetials which will be used by subsequent tasks. It normally would always report `changed` when it runs. This can be suppressed by using `changed_when`:

```yaml
- name: get Kerberos credentials as "admin"
  shell: echo "{{ krb_admin_pass }}" | kinit -f admin
  changed_when: false
```

This next example shows a use-case why you might want to use the above `changed_when` keyword on your tasks. This allows you to report more accurately if something has actually changed.

```yaml
tasks:
  - shell:
      cmd: /usr/local/bin/upgrade-database
    register: command_result
    changed_when: "'Success' in command_result.stdout"
    notify:
      - restart_database

handlers:
  - name: restart_database
     service:
       name: mariadb
       state: restarted
```

## When

This is useful for running specific tasks/blocks when a condition is met. This could be an IPV4 addr, hostname, kernel version or some custom variable/fact. It is put on level with the task like so:

```yaml
- name: task to do something
  yum:
    pkg: httpd
    state: latest
  when: ansible_facts.hostname = 'webserver'
```
| Operation                                                                                       | Example                                   |
| ---                                                                                             | ---                                       |
| Equal (value is a string)                                                                       | ansible_machine == "x86_64"               |
| Equal (value is numeric)                                                                        | max_memory == 512                         |
| Less than                                                                                       | min_memory < 128                          |
| Greater than                                                                                    | min_memory > 256                          |
| Less than or equal to                                                                           | min_memory <= 256                         |
| Greater than or equal to                                                                        | min_memory >= 512                         |
| Not equal to                                                                                    | min_memory != 512                         |
| Variable exists                                                                                 | min_memory is defined                     |
| Variable does not exist                                                                         | min_memory is not defined                 |
| Boolean variable is true.  1, True, or yes evaluate to true. 0, False, or no evaluate to false. | memory_available                          |
| Boolean variable is false.                                                                      | not memory_available                      |
| First variable's value is present as a value in second variable's list                          | ansible_distribution in supported_distros |

## Handlers

`handler`'s work if they are called by a `notify` inside a task. `notify` will only call if a change is made during its run. Handlers can be considered as inactive tasks that only get triggered when explicitly invoked using a notify statement

```yaml
tasks:
  - name: copy demo.example.conf configuration template
    template:
      src: /var/lib/templates/demo.example.conf.template
      dest: /etc/httpd/conf.d/demo.example.conf
    notify:
      - restart apache

handlers:
  - name: restart apache
    service:
      name: httpd
      state: restarted
```

Handlers only run on a `changed` task and are ignored and not notified on a `ok` or `failed` task. To force handlers you add `force_handlers: yes` to the play.

## Blocks

Blocks are used as their name implies, blocks of tasks. Example below (this is useful if needing the `when` conditional for a group of tasks):

```yaml
- name: intsall apache if webserver
  block:
    - name: install package
      yum:
        pkg: httpd
        state: latest
    - name: open firewall port
      firewalld:
        service: http
        state: enabled
        zone: public
        permanent: yes
        immediate: yes
      notify:
      - restart apache
    handlers:
      - name: restart apache
        service:
          name: httpd
          state: restarted
        
  when: ansible_facts.hostname = 'webserver'
```

Blocks also allow for error handling in combination with the rescue and always statements. If any task in a block fails, tasks in its rescue block are executed in order to recover. After the tasks in the block clause run, as well as the tasks in the rescue clause if there was a failure, then tasks in the always clause run. To summarize:

* `block` defines the main tasks to run
* `rescue` defines the tasks to run if the tasks defined in the `block` clause fail
* `always` defines the tasks that will always run independently of the success or failure of tasks defined in the `block` and `rescue` clauses

```yaml
  tasks:
    - block:
        - name: upgrade the database
          shell:
            cmd: /usr/local/lib/upgrade-database
      rescue:
        - name: revert the database upgrade
          shell:
            cmd: /usr/local/lib/revert-database
      always:
        - name: always restart the database
          service:
            name: mariadb
            state: restarted
```

## Loops

The `loop` keyword is added to the task, and takes as a value the list of items over which the task should be iterated. `item` is the iterable in the loop.

Basic Example of loop:

```yaml
- name: MySQL and Apache are started
  service:
    name: "{{ item }}"
    state: started
  loop:
    - mysqld
    - httpd
```

A more elaborate example using vars (could be vars file):

```yaml
vars:
  mail_services:
    - postfix
    - dovecot

tasks:
  - name: Postfix and Dovecot are running
    service:
      name: "{{ item }}"
      state: started
    loop: "{{ mail_services }}"
```

## Errors and Failures

### Errors

`ignore_errors` can be passed alongside a task to continue on even if it errors out: 

```yaml
- name: do the thing
  yum:
    name: packageA
    state: latest
  ignore_errors: yes
```

### Failures

You can specify when a task actually fails by adding in the `failed_when` flag on the task. If you were running a `shell` command you can specify the task being failed by the output of said command.

```yaml
tasks:
  - name: Run user creation script
    shell: /usr/local/bin/create_users.sh
    register: command_result
    failed_when: "'Password missing' in command_result.stdout"
```

The `fail` module can also be used to force a task failure. The above example can be written as two tasks:

```yaml
tasks:
  - name: Run user creation script
    shell: /usr/local/bin/create_users.sh
    register: command_result
    ignore_errors: yes

  - name: Report script failure
    fail:
      msg: "The password is missing in the output"
    when: "'Password missing' in command_result.stdout"
```
The `fail` module can be used to provide a more clear error message for your tasks.
