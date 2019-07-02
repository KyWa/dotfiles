# Terraform

One thing to note is that Terraform loads ALL `*.tf` files in the working directory. So a variables.tf file is only for the human. It could be called antivariable.tf and still pull in the data inside. A single working directory should be used per project to avoid issues of pulling/creating extra infra.

For calling variables that are from `data` instead of a resource you must prefix the name with data: `${data.azurerm_resource_group.resourcegroup.name}`

To call a playbook for Ansible with output vars from Terraform:

```hcl
provisioner "local-exec" { 
    command = "ANSIBLE_HOST_KEY_CHECKING=\"False\" ansible-playbook -u ${var.ssh_username} --private-key=\"~/.ssh/id_rsa\" -i '${azurerm_public_ip.azr_pip.ip_address},' --ask-vault-pass ansible/azure_rhel_config.yml"
}
```
If someone adds a NSG_rule or other resources (not altering items created by Terraform), Terraform will not be able to destroy/edit those items unless doing a `terraform import`. Tested with a NSG_Rule and Terraform was unaware of the manual add.

To give resuurces names based on work env use the following: 
`name = "resourcename-${terraform.workspace}"`

# GCP specifics
When specifying projects, it must be listed in the `provider` block otherwise it will use default.

# Variables
Use a variables file (variables.tf) for initializing variables. This allows you to use blocks like:

```
variable "test_var" {
    description = "Does something variable like"
}
```

Then you have a `terraform.tfvars` file for the actual variables and can have one for prod and stage and whatever else. They are passed through like so:

`terraform apply -var-file=terraform.tfvars`


