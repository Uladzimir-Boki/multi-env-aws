environment = "prod"
resource_group_name = "RG2"
region = "eu-north-1"

# Different IP ranges
vpc_cidr_block = "10.2.0.0/16"
subnet_cidr_block = "10.2.1.0/24"
availability_zone = "eu-north-1b"

# VM configuration - different instance type
ami_id = "ami-0a716d3f3b16d290c"
instance_type = "t3.micro"

# Storage configuration - different bucket name
storage_account_name = "rg2-storage-bucket-001"
storage_versioning = true
storage_encryption = true

key_pair_name = "kp1"