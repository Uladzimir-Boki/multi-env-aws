environment = "dev"
resource_group_name = "RG1"
region = "eu-north-1"

vpc_cidr_block = "10.1.0.0/16"
subnet_cidr_block = "10.1.1.0/24"
availability_zone = "eu-north-1a"

ami_id = "ami-0a716d3f3b16d290c"
instance_type = "t3.micro"

storage_account_name = "rg1-storage-bucket-001"
storage_versioning = true
storage_encryption = true

key_pair_name = "kp1"