# Terraform

One thing to note is that Terraform loads ALL `*.tf` files in the working directory. So a variables.tf file is only for the human. It could be called antivariable.tf and still pull in the variables inside.
