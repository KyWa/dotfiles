# Terraform

One thing to note is that Terraform loads ALL `*.tf` files in the working directory. So a variables.tf file is only for the human. It could be called antivariable.tf and still pull in the data inside. A single working directory should be used per project to avoid issues of pulling/creating extra infra.

For calling variables that are from `data` instead of a resource you must prefix the name with data: `${data.azurerm_resource_group.resourcegroup.name}`

To call a playbook for Ansible with output vars from Terraform:

`provisioner "local-exec" { command = "ANSIBLE_HOST_KEY_CHECKING=\"False\" ansible-playbook -u ${var.ssh_user} --private-key=\"~/.ssh/id_rsa\" --extra-vars='{"aws_subnet_id": ${aws_terraform_variable_here}, "aws_security_id": ${aws_terraform_variable_here} }' -i '${azurerm_public_ip.pnic.ip_address},' ansible/deploy-with-ansible.yml"}`
