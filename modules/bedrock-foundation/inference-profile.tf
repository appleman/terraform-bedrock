resource "aws_bedrock_inference_profile" "profiles" {
  count = length(var.models)

  name = "${var.tags["Project"]}-inference-profile-${random_string.suffix.result}"
  model_source {
    copy_from = var.models[count.index]
  }

  tags      = var.tags
}

