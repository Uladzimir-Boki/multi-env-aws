# Создание секрета в AWS Secrets Manager
resource "aws_secretsmanager_secret" "vm_root_password" {
  name        = "${var.resource_group_name}/vm-ubuntu-password"
  description = "Ubuntu password for VM"
  recovery_window_in_days = 0

  tags = {
    Environment = var.environment
    ResourceGroup = var.resource_group_name
  }
}

# Генерация случайного пароля
resource "random_password" "vm_root" {
  length           = 16
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>:?"
}

# Сохранение пароля в Secrets Manager
resource "aws_secretsmanager_secret_version" "vm_root_password" {
  secret_id     = aws_secretsmanager_secret.vm_root_password.id
  secret_string = random_password.vm_root.result
}

# Data source для получения пароля
data "aws_secretsmanager_secret_version" "vm_root_password" {
  secret_id = aws_secretsmanager_secret.vm_root_password.id
  depends_on = [aws_secretsmanager_secret_version.vm_root_password]
}


