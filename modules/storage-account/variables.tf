variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "resource_group" {
  description = "Resource group name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "versioning" {
  description = "Enable versioning"
  type        = bool
  default     = true
}

variable "encryption" {
  description = "Enable encryption"
  type        = bool
  default     = true
}


