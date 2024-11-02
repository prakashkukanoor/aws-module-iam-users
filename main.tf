locals {
  comman_tags = {
    Environment = var.environment
    ManagedBy   = var.team
  }
  policies = jsondecode(file("${path.module}/${var.policy_json}"))
}

resource "aws_iam_policy" "this" {
  for_each = local.policies

  name        = "${each.key}-policy"
  path        = "${var.path}"
  description = "iam policy"

  policy = jsonencode(each.value)
}