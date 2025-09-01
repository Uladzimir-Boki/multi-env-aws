output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = aws_instance.main.public_ip
}

output "storage_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.storage_account.bucket_name
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = aws_subnet.main.id
}
