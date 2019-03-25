# Terraform

One thing to note is that Terraform loads ALL `*.tf` files in the working directory. So a variables.tf file is only for the human. It could be called antivariable.tf and still pull in the data inside. A single working directory should be used per project to avoid issues of pulling/creating extra infra.

For calling variables that are from `data` instead of a resource you must prefix the name with data: `${data.azurerm_resource_group.resourcegroup.name}`
