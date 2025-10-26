locals {
  execution_role_name = "${var.tags["Project"]}-bedrock-role-${random_string.suffix.result}"
}

resource "aws_iam_role" "bedrock_execution" {
  count = var.execution_role.create ? 1 : 0
  name  = "${var.tags["Project"]}-bedrock-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for principal in var.execution_role.trusted_principals : {
        Effect = "Allow"
        Principal = {
          Service = principal
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "bedrock_execution_policy" {
  count = var.execution_role.create ? 1 : 0
  name  = "${aws_iam_role.bedrock_execution[0].name}-policy"
  role  = aws_iam_role.bedrock_execution[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowInvokeBedrockModels"
        Effect   = "Allow"
        Action   = ["bedrock:InvokeModel","bedrock:InvokeModelWithResponseStream"]
        Resource = [for profile in aws_bedrock_inference_profile.profiles : profile.arn]
        Condition = var.guardrails.enable ? { StringEquals = { "aws:ResourceTag/GuardrailArn" = aws_bedrock_guardrail.shared[0].guardrail_arn } } : {}
      },
      {
        Sid    = "AllowReadInferenceProfiles"
        Effect = "Allow"
        Action = ["bedrock:GetInferenceProfile","bedrock:ListInferenceProfiles"]
        Resource = "*"
      },
      {
        Sid    = "AllowLogging"
        Effect = "Allow"
        Action = ["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents"]
        Resource = "*"
      }
    ]
  })

  depends_on = [
    aws_bedrock_guardrail.shared,
    aws_iam_role.bedrock_execution
  ]
}