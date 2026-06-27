terraform {
  backend "s3" {
    bucket       = "ecs-demo-terraform-state-980921723264-us-east-1"
    key          = "terraform-ecs-fargate-spot/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
