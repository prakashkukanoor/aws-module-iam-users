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
  pgp_key = file("${var.public_key_file_path}")

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




