provider "aws" {
  alias  = "principal"
  region = "us-west-2"
}

provider "aws" {
  alias  = "cicd"
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::CICD_ACCOUNT_ID:role/admin"
  }
}

provider "aws" {
  alias  = "tfstates"
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::TFSTATES_ACCOUNT_ID:role/admin"
  }
}

module "github-control-cicd" {
  source  = "infrahouse/ci-cd/aws"
  version = "1.0.4"

  providers = {
    aws          = aws.principal
    aws.cicd     = aws.cicd
    aws.tfstates = aws.tfstates
  }

  gh_org       = "my-org"
  gh_repo      = "github-control"
  state_bucket = "my-org-github-control-state"
}

output "github_role_arn" {
  value = module.github-control-cicd.github-role
}

output "admin_role_arn" {
  value = module.github-control-cicd.admin-role
}

output "state_manager_role_arn" {
  value = module.github-control-cicd.state-manager-role
}

output "state_bucket_name" {
  value = module.github-control-cicd.bucket_name
}
