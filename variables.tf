variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region in which the resource to be created"

}

variable "environment" {
  type        = string
  description = "Environment in which the resource to be created"
}

variable "team" {
  type        = string
  description = "Team owner for this resource"
}

variable "policy_json" {
  type        = string
  description = "Name of the json file with policy"
}

variable "bucket_name" {
  description = "Name for the S3 bucket"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Name for the DynamoDB table for state locking"
  type        = string
}

variable "users" {
  description = "Map of policy names to lists of users for each IAM group."
  type        = map(list(string))
}