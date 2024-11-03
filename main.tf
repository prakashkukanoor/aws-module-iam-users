locals {
  policies = jsondecode(templatefile("${path.module}/${var.policy_json}", {
    dynamodb_table_name = var.dynamodb_table_name
    bucket_name         = var.bucket_name
  }))
  common_tags = {
    environment = var.environment
    owner       = var.team
    createdBy   = "terraform"
  }
  
}

resource "aws_iam_policy" "this" {
  for_each = { for policy in local.policies : policy.name => policy }

  name        = "${each.value.name}-policy"
  path        = each.value.path
  description = "iam policy"

  policy = jsonencode(each.value.policy_statement)
  tags   = local.common_tags
}