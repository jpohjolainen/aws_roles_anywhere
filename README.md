# Roles Anywhere Terraform 

This repo has TF code to create AWS Private CA and AWS RolesAnywhere Trust Anchor, Profile and IAM Role with AmazonS3ReadOnlyAccess policy.

Check the variables in [`terraform.tfvar`](/terraform.tfvars) and change them to suit you.

Plan first 
```sh
terraform plan -out tf.plan
```

If all looks good, then apply the plan
```sh
terraform apply tf.plan
```

And to remove all services and configs
```sh
terraform destroy
```
