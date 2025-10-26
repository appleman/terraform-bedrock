variable "enable_inference_profiles" {
  description = "Feature flag to enable inference profiles creation"
  type        = bool
  default     = true
}


variable "execution_role" {
  description = "Execution role configuration: create, trusted principals"
  type = object({
    create            = bool
    trusted_principals = list(string)
  })
  default = {
    create = true
    trusted_principals = ["bedrock.amazonaws.com"]
  }
}

variable "guardrails" {
  description = "Feature flag and tier selection for guardrails"
  type = object({
    enable = bool
    tier   = string
  })
  default = {
    enable = true
    tier   = "medium"
  }
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags applied to all Bedrock resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Owner       = "agent-platform"
    Project     = "agentic-foundation"
  }
}

variable "models" {
  description = "Mode ID or ARN"
  type = list(string)
  default = ["arn:aws:bedrock:us-east-1:533267348128:inference-profile/global.anthropic.claude-sonnet-4-5-20250929-v1:0"]
}