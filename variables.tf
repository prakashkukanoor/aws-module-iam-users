variable "region" {
  type = string
  default = "us-east-1"
  description = "Region in which the resource to be created"
  
}

variable "path" {
  type = string
  description = "Provide the path for policy, role & user ensure to include '/' at the beginning and ending of path"
}

variable "environment" {
  type = string
  description = "Environment in which the resource to be created"
}

variable "team" {
  type = string
  description = "Team owner for this resource"
}

variable "policy_json" {
  type = string
  description = "Name of the json file with policy"
}