# Roles Anywhere Terraform 

This repo has TF code to create AWS Private CA and AWS RolesAnywhere Trust Anchor, Profile and IAM Role with AmazonS3ReadOnlyAccess policy.

Check the variables in [`terraform.tfvar`](/terraform.tfvars) and change them to suit you.

**NOTE**: AWS Private CA costs 300e ($400) a month. Only first one is free for 30 days. If you create one, then delete it, and then create new one, you will be charged.

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
