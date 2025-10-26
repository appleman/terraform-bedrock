# Bedrock Foundation Module

This module creates a production-ready Bedrock foundation setup:

- Guardrail config section (enable/disable, tier selection)
- Execution role section (create/disable, trusted principals, trust policy update)
- Inference profiles section (one per model)

## Feature Flags
- `guardrails = { enable = true, tier = medium }`
- `execution_role = { create = true, trusted_principals = ["bedrock.amazonaws.com"] }`
- `enable_inference_profiles` - toggle inference profiles creation

## Usage Example

```hcl
module "bedrock_foundation" {
  source = "./bedrock-foundation-module"

  region = "us-east-1"

  tags = {
    Environment = "dev"
    Owner       = "agent-platform"
  }

  guardrails = { enable = true, tier = "medium" }
  execution_role = { create = true, trusted_principals = ["bedrock.amazonaws.com"] }
  enable_inference_profiles = true

  models = {
    "anthropic.claude-3-sonnet" 
    "amazon.titan-text-premier-v1"
  }
}
