# Backend Bootstrap

Creates the S3 bucket required by the root Terraform S3 backend.

Run this once before `terraform init` in the project root:

```bash
cd bootstrap/backend
terraform init
terraform apply
cd ../..
terraform init
```

The root backend uses native S3 lockfiles with `use_lockfile = true`, so no DynamoDB lock table is required.
