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

output "policy" {
  value = [for key, value in aws_iam_policy.this: key]
  
}
resource "aws_iam_group" "this" {
  for_each = aws_iam_policy.this

  name = "${each.key}-group"
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each = aws_iam_policy.this

  group      = aws_iam_group.this[each.key].name
  policy_arn = each.value.arn
}

resource "aws_iam_user" "users" {
  for_each = tomap({
    for policy_name, user_obj in var.users :
    policy_name => {
      for user, path in user_obj :
      "${policy_name}-${user}" => {
        policy_name = policy_name
        user_name   = user
        user_path = path
      }
    }
  })

  name = each.value.user_name
  path = each.value.user_path

  tags = common_tags
}

# resource "aws_iam_user_group_membership" "user_group_membership" {
#   for_each = aws_iam_user.users

#   user = each.value.user_name
#   groups = [
#     aws_iam_group.this[each.value.policy_name].name
#   ]
# }




