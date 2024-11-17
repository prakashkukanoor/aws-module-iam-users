locals {
  policies = jsondecode(templatefile("${path.module}/${var.policy_json}", {
    dynamodb_table_name = var.dynamodb_table_name
    bucket_name         = var.bucket_name
  }))
  path_to_group = { for policy in local.policies : policy.path => policy.name }
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
  for_each = { for users in var.users : users.user => users.path }

  name = each.key
  path = each.value

  tags = local.common_tags
}

resource "aws_iam_access_key" "this" {
  for_each = aws_iam_user.users
  pgp_key = "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"

  user    = each.value.name
}

resource "aws_iam_user_group_membership" "user_group_membership" {
  for_each = aws_iam_user.users

  user = each.value.name
  groups = [
    aws_iam_group.this[local.path_to_group[each.value.path]].name
  ]
}

resource "local_file" "csv_file" {
  filename = "iam_users_access_keys.csv"

  content = <<EOT
UserName,AccessKeyId,SecretAccessKey
${join("\n", [for user, access_key in aws_iam_access_key.this : "${access_key.user},${access_key.id},${access_key.encrypted_secret}"])}
EOT
}




