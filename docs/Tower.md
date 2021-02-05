# Ansible Tower

## Misc Notes

If you want to be able to specify `extra_vars` on a schedule, you must select Prompt on Launch for EXTRA VARIABLES on the job template, or a enable a survey on the job template, then those answered survey questions become `extra_vars`.
