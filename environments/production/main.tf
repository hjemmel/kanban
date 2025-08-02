module "swarm" {
  source                = "../../modules/cloud/aws/compute/swarm"
  private_key_path      = "${path.module}/private_key.pem"
  account_id            = var.account_id
  age_key_path          = "${path.module}/key.txt"
  compose_file          = "../../compose.yaml"
  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
  gh_pat                = var.gh_pat
  gh_owner              = "hjemmel"
  image_to_deploy       = "ghcr.io/hjemmel/kanban:latest"
}

module "repository_secrets" {
  source = "../../modules/integrations/github/secrets"
  secrets = {
    "PRIVATE_KEY"           = module.swarm.private_key,
    "AWS_ACCESS_KEY_ID"     = var.aws_access_key_id,
    "AWS_SECRET_ACCESS_KEY" = var.aws_secret_access_key,
    "AGE_KEY"               = var.age_key,
    "GH_PAT"                = var.gh_pat,
    "CODE_COV_TOKEN"        = var.code_cov
  }
  repository   = "kanban"
  github_owner = "hjemmel"
}

module "contributing_workflow" {
  source       = "../../modules/integrations/github/contributing_workflow"
  repository   = "kanban"
  github_owner = "hjemmel"
  status_checks = [
    "Compile with mix test, format, dialyzer & unused deps check"
  ]
}

# module "sops" {
#   source                = "../../modules/integrations/sops"
#   private_key_file_path = "${path.module}/key.txt"
#   sops_config_file_path = "../../.sops.yaml"
# }

output "swarm_ssh_commands" {
  value = module.swarm.ssh_commands
}

# output "age_public_key" {
#   value = module.sops.public_key
# }
