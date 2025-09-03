module "storage_account" {
  source = "./modules/storage-account"

  bucket_name      = var.storage_account_name
  environment      = var.environment
  resource_group   = var.resource_group_name
  region           = var.region
  versioning       = var.storage_versioning
  encryption       = var.storage_encryption
}