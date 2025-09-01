terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "uladzimir-boki-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "eu-north-1"
    profile = "trainee"
    dynamodb_table = "uladzimir-boki-terraform-lock"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}

resource "aws_resourcegroups_group" "main" {
  name = var.resource_group_name

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "ResourceGroup",
      "Values": ["${var.resource_group_name}"]
    }
  ]
}
JSON
  }

  tags = {
    Environment = var.environment
    ResourceGroup = var.resource_group_name
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.resource_group_name}-vpc"
    Environment = var.environment
    ResourceGroup = var.resource_group_name
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.resource_group_name}-subnet"
    Environment = var.environment
    ResourceGroup = var.resource_group_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.resource_group_name}-igw"
    Environment = var.environment
    ResourceGroup = var.resource_group_name
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.resource_group_name}-rt"
    Environment = var.environment
    ResourceGroup = var.resource_group_name
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "vm" {
  name        = "${var.resource_group_name}-vm-sg"
  description = "Security group for VM"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.resource_group_name}-vm-sg"
    Environment = var.environment
    ResourceGroup = var.resource_group_name
  }
}

resource "aws_instance" "main" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.vm.id]
  key_name               = var.key_pair_name

  user_data = <<-EOF
              #!/bin/bash
              echo "root:${data.aws_secretsmanager_secret_version.vm_root_password.secret_string}" | chpasswd
              sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config 
              sed -i 's/^PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config 
              sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config 
              sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/60-cloudimg-settings.conf
              systemctl restart ssh.service
              EOF

  tags = {
    Name        = "${var.resource_group_name}-vm"
    Environment = var.environment
    ResourceGroup = var.resource_group_name
  }

  depends_on = [aws_secretsmanager_secret_version.vm_root_password]
}

