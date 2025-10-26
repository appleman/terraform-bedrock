data "aws_caller_identity" "current" {}

module "bedrock_foundation" {
  source = "../../modules/bedrock-foundation"

  region = "us-east-1"

  tags = {
    Project     = "agent-platform"
    Environment = "dev"
    Owner       = "team-agent"
  }

  # Feature flags
  guardrails = { enable = true, tier = "medium" }
  execution_role = { create = true, trusted_principals = ["bedrock.amazonaws.com"] }
  enable_inference_profiles = true

  # List of model ARNs
  models = [
    "arn:aws:bedrock:us-east-1:${data.aws_caller_identity.current.account_id}:inference-profile/global.anthropic.claude-sonnet-4-5-20250929-v1:0"
  ]
}

# Outputs
output "bedrock_execution_role_arn" {
  value = module.bedrock_foundation.execution_role_arn
}

output "inference_profiles" {
  value = module.bedrock_foundation.inference_profile_arns
}

output "guardrail_arn" {
  value = module.bedrock_foundation.guardrail_arn
}