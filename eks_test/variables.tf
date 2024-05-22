# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-2"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0a638b5443d52eed0"
}
variable "subnet_id" {
  type    = list(string)
  default = ["subnet-059116372b7c19ae8", "subnet-0252aeed7749e93e0"]
}