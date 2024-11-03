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

resource "aws_iam_role" "this" {
  for_each = aws_iam_policy.this

  name = "${each.key}_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = aws_iam_policy.this

  role       = aws_iam_role.this[each.key].name
  policy_arn = each.value.arn
}

resource "aws_iam_group" "this" {
  for_each = aws_iam_policy.this

  name = "${each.key}_group"
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each = aws_iam_policy.this

  group      = aws_iam_group.this[each.key].name
  policy_arn = each.value.arn
}

resource "aws_iam_user" "users" {
  for_each = tomap({
    for policy_name, user_list in var.users :
    policy_name => {
      for user in user_list :
      "${policy_name}-${user}" => {
        policy_name = policy_name
        user_name   = user
      }
    }
  })

  name = each.value.user_name
}

resource "aws_iam_user_group_membership" "user_group_membership" {
  for_each = aws_iam_user.users

  user = each.value.user_name
  groups = [
    aws_iam_group.this[each.value.policy_name].name
  ]
}




