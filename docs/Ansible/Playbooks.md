# Playbooks

## Syntax

Each block of hosts/tasks in a `playbook` is a `play`. You can have multiple plays in a playbook or a single play. There are uses for multiple plays (large complex environments with their own unqiue vars and needs that is easier to run in separate plays as opposed to adding roles to existing plays).

```
---
# This is a simple playbook with two plays

-  name: first play
   hosts: web.example.com
   tasks:

   - name: first task
     yum:
       name: httpd
       status: present

   - name: second task
     service:
       name: httpd
       enabled: true


-  name: second play
   hosts: database.example.com
   tasks:

   - name: first task
     service:
       name: mariadb
       enabled: true
```

### Strings

Strings can be portrayed with any of the following methods:

```
I am a string
'I am also a string'
"I too am a string"
```

### Multi-Line Strings

There are 2 methods for doing this as outlined below. The first method using `|` preserves newline characters AFTER the `|`.

```
include_newlines: |
        Example Company
        123 Main Street
        Atlanta, GA 30303
```

You can also write multiline strings using the greater-than (>) character to indicate that newline characters are to be converted to spaces and that leading white spaces in the lines are to be removed. This method is often used to break long strings at space characters so that they can span multiple lines for better readability.

```
fold_newlines: >
        This is
        a very long,
        long, long, long
        sentence.
```

### Dictionaries

As with most languages, dictionaries are wrote out like so:

```
{name: svcrole, svcservice: httpd, svcport: 80}
```

### Lists

Lists can be written out in a few ways. First is with single-dash per item in the list:

```
hosts:
  - serverA
  - serverB
  - serverC
```

Or in an inline fashion (note because this is Python, lists are encapsulated in `[ ]`)

```
hosts: [serverA, serverB, serverC]
```
