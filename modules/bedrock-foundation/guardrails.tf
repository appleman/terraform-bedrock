locals {
  guardrail_tiers = {
    basic = {
      content_input  = "LOW"
      content_output = "LOW"
      topic_tier     = "CLASSIC"
    }
    medium = {
      content_input  = "MEDIUM"
      content_output = "MEDIUM"
      topic_tier     = "STANDARD"
    }
    restrictive = {
      content_input  = "HIGH"
      content_output = "HIGH"
      topic_tier     = "STRICT"
    }
  }

  selected_tier = lookup(local.guardrail_tiers, var.guardrails.tier, local.guardrail_tiers["medium"])
}

resource "aws_bedrock_guardrail" "shared" {
  count = var.guardrails.enable ? 1 : 0

  name                      = "${var.tags["Project"]}-guardrails-${random_string.suffix.result}"
  description               = "Shared guardrail for all models"

  blocked_input_messaging   = "⚠️ Input content violates policy."
  blocked_outputs_messaging = "⚠️ Output content blocked by safety policy."
  tags                      = var.tags

  content_policy_config {
    filters_config {
      input_strength  = "MEDIUM"
      output_strength = "MEDIUM"
      type            = "HATE"
    }
    tier_config {
      tier_name = "CLASSIC"
    }
  }

  sensitive_information_policy_config {
    pii_entities_config {
      action         = "BLOCK"
      input_action   = "BLOCK"
      output_action  = "ANONYMIZE"
      input_enabled  = true
      output_enabled = true
      type           = "NAME"
    }

    regexes_config {
      action         = "BLOCK"
      input_action   = "BLOCK"
      output_action  = "BLOCK"
      input_enabled  = true
      output_enabled = false
      description    = "example regex"
      name           = "regex_example"
      pattern        = "^\\d{3}-\\d{2}-\\d{4}$"
    }
  }

  topic_policy_config {
    topics_config {
      name       = "investment_topic"
      examples   = ["Where should I invest my money ?"]
      type       = "DENY"
      definition = "Investment advice refers to inquiries, guidance, or recommendations regarding the management or allocation of funds or assets with the goal of generating returns ."
    }
    tier_config {
      tier_name = "CLASSIC"
   }
  }

  cross_region_config  {
     guardrail_profile_identifier = "arn:aws:bedrock:us-east-1:${data.aws_caller_identity.current.account_id}:guardrail-profile/us.guardrail.v1:0"
  }

}

