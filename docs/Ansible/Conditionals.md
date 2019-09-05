# Ansible Conditionals

## When

This is useful for running specific tasks/blocks when a condition is met. This could be an IPV4 addr, hostname, kernel version or some custom variable/fact. It is put on level with the task like so:

```yaml
- name: task to do something
  yum:
    pkg: httpd
    state: latest
  when: ansible_facts.hostname = 'webserver'
```


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
