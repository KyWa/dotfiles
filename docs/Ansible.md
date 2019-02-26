# Ansible

For playbooks to not gather facts you can disable it by adding the following to the top of the playbook: `gather_facts: no`

`handler`'s work if they are called by a `notify` inside a task. `notify` will only call if a change is made during its run.
