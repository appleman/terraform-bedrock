# -----------------------------------------------------------------------------
# Outputs
# -----------------------------------------------------------------------------

locals {
  model_names = [
    for arn in var.models :
    split("/", arn)[1]  # splits on "/" and takes the last part
  ]
}

output "guardrail_arn" {
  value = var.guardrails.enable ? aws_bedrock_guardrail.shared[0].guardrail_arn : ""
}

output "inference_profile_arns" {
  value = {
    for i, arn in var.models :
    local.model_names[i] => aws_bedrock_inference_profile.profiles[i].arn
  }
}

output "execution_role_arn" {
  description = "ARN of the execution role"
  value       = var.execution_role.create ? aws_iam_role.bedrock_execution[0].arn : ""
}

output "execution_role_name" {
  description = "Derived execution role name"
  value       = var.execution_role.create ? aws_iam_role.bedrock_execution[0].name : ""
}