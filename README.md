# Terraform_VM
TF module for Azure VM with a private nic, ssh key setup, and optional data disk on creation

# Usage example

    module "vm" {
      source = "./vm"
      # Variables
      public_ssh_key_path = var.vm_public_ssh_key_path
      GLOBAL_TAGS = merge(local.GLOBAL_TAGS, {
        service = "elastic",
        db      = "true",
        elastic = "true"
      })
      computer_name           = var.elastic_computer_name
      create_data_disk        = var.elastic_create_data_disk
      data_disk_size          = local.env_to_elastic_storage_data_disk[terraform.workspace]["disk_size_gb"]
      data_disk_type          = local.env_to_elastic_storage_data_disk[terraform.workspace]["storage_account_type"]
      env_prefix              = local.env_prefix
      location                = local.resource_group.location
      os_disk_size            = local.env_to_elastic_storage_os_disk[terraform.workspace]["disk_size_gb"]
      os_disk_type            = local.env_to_elastic_storage_os_disk[terraform.workspace]["managed_disk_type"]
      resource_group_name     = local.resource_group.name
      storage_data_disk       = local.elastic_storage_data_disk
      storage_image_reference = local.elastic_storage_image_reference
      storage_os_disk         = local.elastic_storage_os_disk
      subnet_id               = local.db_subnet.id
      vm_ip_addr              = local.elastic_vm_ip_addr
      vm_size                 = local.elastic_vm_size

    }
