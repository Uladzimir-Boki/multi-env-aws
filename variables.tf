variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
}

variable "subnet_cidr_block" {
  description = "CIDR block for subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = "eu-north-1a"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "storage_account_name" {
  description = "Name for the S3 bucket"
  type        = string
}

variable "storage_versioning" {
  description = "Enable versioning for S3 bucket"
  type        = bool
  default     = true
}

variable "storage_encryption" {
  description = "Enable encryption for S3 bucket"
  type        = bool
  default     = true
}

variable "key_pair_name" {
  description = "Key pair name"
  type = string
}