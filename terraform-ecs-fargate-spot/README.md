# Terraform ECS Fargate Spot TRS Platform

Production-ready Terraform project for deploying the TRS containerized application on Amazon ECS Fargate Spot in AWS account `980921723264`, region `us-east-1`.

## Architecture

Traffic flow:

```text
Internal User
  -> Private Route53 Hosted Zone: trs.internal
  -> Alias Record: api.trs.internal
  -> Internet-facing Network Load Balancer
  -> Internal Application Load Balancer
  -> Amazon ECS Cluster on AWS Fargate Spot
  -> TRS Containerized Application
       -> Aurora PostgreSQL
       -> Amazon S3
       -> WriteAPI
       -> Data Lake
       -> CXO
       -> MDS
       -> P&I
       -> Atlas Email Proxy
       -> ADFS
```

Authentication is represented through TRS application environment and Secrets Manager integration with ADFS metadata and Atlas Email Proxy endpoint configuration. TLS is terminated on the internal ALB using ACM. The NLB forwards TCP traffic to the ALB target group.

## Folder Structure

```text
terraform-ecs-fargate-spot/
|-- backend.tf
|-- provider.tf
|-- versions.tf
|-- variables.tf
|-- terraform.tfvars
|-- outputs.tf
|-- main.tf
|-- README.md
|-- backend/
|-- environments/
|   |-- dev.tfvars
|   |-- qa.tfvars
|   `-- prod.tfvars
`-- modules/
    |-- acm/
    |-- alb/
    |-- aurora-postgres/
    |-- autoscaling/
    |-- cloudwatch/
    |-- ecr/
    |-- ecs-cluster/
    |-- ecs-service/
    |-- iam/
    |-- kms/
    |-- logging/
    |-- nlb/
    |-- route53/
    |-- s3/
    |-- secrets-manager/
    |-- security-groups/
    `-- vpc/
```

Each module contains `main.tf`, `variables.tf`, `outputs.tf`, and `README.md`.

## Prerequisites

- Terraform `>= 1.6`
- AWS CLI authenticated to account `980921723264`
- IAM permissions to create VPC, ECS, ELB, Route53, ACM, RDS, S3, ECR, IAM, KMS, CloudWatch, CloudTrail, Secrets Manager, and Application Auto Scaling resources
- Existing remote-state bootstrap S3 bucket: `ecs-demo-terraform-state-980921723264-us-east-1` in `us-east-1`
- Docker installed for application image builds

## Remote State

`backend.tf` configures S3 remote state with native S3 lockfiles:

```hcl
bucket         = "ecs-demo-terraform-state-980921723264-us-east-1"
key            = "terraform-ecs-fargate-spot/terraform.tfstate"
region         = "us-east-1"
use_lockfile   = true
encrypt        = true
```

Backend blocks cannot reference variables. Change these literal values only if the backend bootstrap resources differ.

### Bootstrap the backend bucket

If `terraform init` fails with `NoSuchBucket`, create the backend bucket first:

```powershell
cd "d:\ECS Cluster\terraform-ecs-fargate-spot\bootstrap\backend"
terraform init
terraform apply
cd "d:\ECS Cluster\terraform-ecs-fargate-spot"
terraform init
```

The root backend uses `use_lockfile = true`, so a DynamoDB lock table is not required for Terraform versions that support S3 native state locking.

## Terraform Commands

Initialize:

```bash
terraform init
```

Format:

```bash
terraform fmt -recursive
```

Validate:

```bash
terraform validate
```

Plan for dev:

```bash
terraform plan -var-file="environments/dev.tfvars" -out=tfplan
```

Apply for dev:

```bash
terraform apply tfplan
```

Plan/apply QA or prod by changing the var file:

```bash
terraform plan -var-file="environments/qa.tfvars" -out=tfplan
terraform apply tfplan

terraform plan -var-file="environments/prod.tfvars" -out=tfplan
terraform apply tfplan
```

## Deployment Steps

1. Confirm the backend S3 bucket exists in the region configured in `backend.tf`.
2. Update `terraform.tfvars` or the selected environment file with real enterprise endpoints:
   - `adfs_metadata_url`
   - `atlas_email_proxy_url`
   - `writeapi_url`
   - `data_lake_url`
   - `cxo_url`
   - `mds_url`
   - `pi_url`
   - `notification_email`
3. Build and push the TRS image to ECR.
4. Run `terraform init`.
5. Run `terraform fmt -recursive` and `terraform validate`.
6. Run `terraform plan -var-file="environments/<env>.tfvars" -out=tfplan`.
7. Review the plan.
8. Run `terraform apply tfplan`.
9. Confirm the ECS service is stable and `api.trs.internal` resolves from inside the VPC/private DNS environment.

## Docker Build and Push

After ECR is created, authenticate and push the image:

```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 980921723264.dkr.ecr.us-east-1.amazonaws.com

docker build -t trs:latest .
docker tag trs:latest 980921723264.dkr.ecr.us-east-1.amazonaws.com/trs:latest
docker push 980921723264.dkr.ecr.us-east-1.amazonaws.com/trs:latest
```

For immutable ECR tags, prefer environment or build-specific tags:

```bash
docker tag trs:latest 980921723264.dkr.ecr.us-east-1.amazonaws.com/trs:dev-20260627-001
docker push 980921723264.dkr.ecr.us-east-1.amazonaws.com/trs:dev-20260627-001
terraform apply -var-file="environments/dev.tfvars" -var="container_image_tag=dev-20260627-001"
```

## Destroy Steps

Use extreme care in shared and production accounts.

```bash
terraform plan -destroy -var-file="environments/dev.tfvars" -out=destroy.tfplan
terraform apply destroy.tfplan
```

Production resources enable deletion protection by default. To destroy prod, explicitly disable deletion protection first:

```bash
terraform apply -var-file="environments/prod.tfvars" \
  -var="enable_deletion_protection=false" \
  -var="aurora_deletion_protection=false"
```

Then run the destroy plan. Aurora final snapshots are retained.

## Module Description

| Module | Description |
|---|---|
| `vpc` | Creates the `10.0.0.0/16` VPC across `us-east-1a` and `us-east-1b`, including public, ECS private, and database subnets, IGW, NAT gateways, route tables, NACLs, and subnet associations. |
| `security-groups` | Creates separate security groups for NLB, ALB, ECS tasks, and Aurora PostgreSQL with least-privilege ingress/egress. |
| `iam` | Creates ECS task execution and task IAM roles with scoped permissions for ECR, CloudWatch Logs, Secrets Manager, SSM ECS Exec, CloudWatch metrics, S3, and KMS. |
| `ecs-cluster` | Creates an ECS cluster with Container Insights and capacity providers `FARGATE` and `FARGATE_SPOT`; Spot has weight `100`, Fargate has weight `1`. |
| `ecs-service` | Deploys the TRS task definition and ECS service with CPU `1024`, memory `2048`, desired count `2`, ECS Exec, rolling deployments, circuit breaker rollback, ALB target registration, logs, environment variables, and Secrets Manager secrets. |
| `alb` | Creates an internal ALB with HTTPS listener, HTTP redirect, ECS target group, health checks, sticky sessions, access logs, and deletion protection. |
| `nlb` | Creates an internet-facing NLB with cross-zone load balancing, access logs, TCP listeners, and an ALB target group. |
| `route53` | Creates/supports the private hosted zone `trs.internal` and alias record `api.trs.internal` pointing to the NLB. |
| `acm` | Requests and DNS-validates an ACM certificate for `api.trs.internal`. |
| `aurora-postgres` | Creates encrypted Aurora PostgreSQL with writer and reader instances, Multi-AZ subnet placement, backup retention, Performance Insights, CloudWatch log exports, and Secrets Manager password consumption. |
| `s3` | Creates an encrypted, versioned, private S3 bucket with lifecycle rules, server access logs, public access block, and TLS-only bucket policy. |
| `ecr` | Creates encrypted ECR repository `trs` with image scanning, immutable tags, and lifecycle policy. |
| `secrets-manager` | Stores generated database credentials, JWT secret, application secrets, and SMTP password using the Secrets Manager CMK. |
| `cloudwatch` | Creates log groups, metric filters, alarms, SNS email subscription, and dashboard widgets for ECS, ALB, NLB, and Aurora. |
| `autoscaling` | Configures ECS Application Auto Scaling from min `2` to max `10`, with CPU and memory scaling thresholds and alarms. |
| `kms` | Creates CMKs for S3, Aurora, Secrets Manager, and CloudWatch with rotation enabled. |
| `logging` | Creates ALB/NLB/S3/CloudTrail access log bucket, VPC Flow Logs, and CloudTrail with log file validation. |

## Production Defaults

- VPC CIDR: `10.0.0.0/16`
- Availability zones: `us-east-1a`, `us-east-1b`
- ECS task CPU/memory: `1024` / `2048`
- ECS desired count: `2`
- ECS autoscaling min/max: `2` / `10`
- ECS capacity strategy: `FARGATE_SPOT` weight `100`, `FARGATE` weight `1`
- Aurora backup retention: `7` days
- CloudWatch log retention: `30` days
- ALB deletion protection: enabled
- Aurora deletion protection: enabled
- S3 versioning/encryption/public access block: enabled
- KMS key rotation: enabled

## Outputs

The root module outputs:

- VPC ID
- Public, private ECS, and database subnet IDs
- ALB DNS and ARN
- NLB DNS and ARN
- ECS cluster ARN/name
- ECS service name
- Aurora writer and reader endpoints
- Aurora credentials secret ARN
- S3 bucket name and ARN
- Route53 zone ID/name and API FQDN
- ECR repository URL
- CloudWatch dashboard name and ARN
- KMS key ARNs

## Troubleshooting

### Terraform backend bucket does not exist or is in a different region

Create the backend S3 bucket before running `terraform init`, or update `backend.tf` to match existing bootstrap resources. If Terraform reports a bucket region mismatch, set the backend `region` to the bucket's actual region and re-run `terraform init -reconfigure`.

### ACM certificate validation is stuck

The ACM module creates DNS validation records in the private hosted zone. Confirm the hosted zone exists and the account can create Route53 records. Internal/private certificates may require organization-specific DNS or Private CA practices depending on enterprise policy.

### ECS tasks do not start

Check:

```bash
aws ecs describe-services --cluster <cluster-name> --services <service-name> --region us-east-1
aws logs tail /ecs/<name-prefix>/trs --follow --region us-east-1
```

Common causes are missing container image tags, failed health checks, incorrect app port, or secret access errors.

### NLB or ALB health checks fail

Confirm the TRS container responds with HTTP `200-399` on `health_check_path`, default `/health`, and listens on `container_port`, default `8080`.

### Cannot resolve api.trs.internal

Confirm the resolver is inside the VPC or connected network associated with the Route53 private hosted zone. Private hosted zones do not resolve publicly.

### Aurora connection fails

Confirm ECS task security group egress to Aurora and Aurora ingress from ECS tasks on TCP `5432`. Confirm the application reads the database secret and uses the Aurora writer endpoint.

### ECR image push fails

Authenticate Docker to ECR and ensure the repository exists:

```bash
aws ecr describe-repositories --repository-names trs --region us-east-1
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 980921723264.dkr.ecr.us-east-1.amazonaws.com
```

### Deletion protection prevents destroy

Set these variables to `false`, apply, then destroy:

```bash
-var="enable_deletion_protection=false" -var="aurora_deletion_protection=false"
```

## Security Notes

- Do not commit real passwords or secret values.
- Runtime secrets are generated and stored in AWS Secrets Manager.
- Use private connectivity for internal users where possible.
- Review `allowed_internal_cidrs` before production deployment.
- Replace example integration URLs before deployment.
- Keep `.terraform/` out of version control.
