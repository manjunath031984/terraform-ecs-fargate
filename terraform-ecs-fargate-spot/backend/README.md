# Backend Bootstrap

Creates the S3 bucket required by the root Terraform S3 backend.

Run this once before `terraform init` in the project root:

```bash
cd backend
terraform init
terraform apply
cd ..
terraform init
```

Destroying this backend stack deletes this versioned bucket and all Terraform state objects by default. Recreate the destroy plan before applying so the plan includes `force_destroy = true`. To preserve bucket contents, pass `-var="force_destroy_state_bucket=false"` when planning the destroy.

The root backend uses native S3 lockfiles with `use_lockfile = true`, so no DynamoDB lock table is required.
