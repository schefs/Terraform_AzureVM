# Terraform_VM
TF module for Azure VM with a private nic, ssh key setup, and optional data disk on creation

tested on TF 0.12+ versions inclding 0.12 syntax

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

# Variables used

    variable "elastic_create_data_disk" {
      default = "true"
    }

    variable "elastic_computer_name" {
      default = "elastic"
    }

    variable elastic_public_ssh_key_path {
      default = "~/.ssh/elastic/id_rsa.pub"
    }

    locals {
      env_to_elastic_ip_addr = {
        dev  = "10.10.10.10"
        prod = "10.10.10.10"
      }
      env_to_elastic_vm_size = {
        dev  = "Standard_DS1_v2"
        prod = "Standard_E16s_v3"
      }
      env_to_elastic_storage_os_disk = {
        dev = {
          name              = "dev_elastic-os-disk1"
          caching           = "ReadWrite"
          create_option     = "FromImage"
          managed_disk_type = "Premium_LRS"
          disk_size_gb      = "256"
        }
        prod = {
          name              = "prod_elastic-os-disk1"
          caching           = "ReadWrite"
          create_option     = "FromImage"
          managed_disk_type = "Premium_LRS"
          disk_size_gb      = "256"
        }
      }
      env_to_elastic_storage_data_disk = {
        dev = {
          name                 = "dev_elastic-data-disk1"
          lun                  = "1"
          caching              = "ReadWrite"
          create_option        = "Empty"
          storage_account_type = "Premium_LRS"
          disk_size_gb         = "256"
        }
        prod = {
          name                 = "prod_elastic-data-disk1"
          lun                  = "1"
          caching              = "ReadWrite"
          create_option        = "Empty"
          storage_account_type = "Premium_LRS"
          disk_size_gb         = "256"
        }
      }
      env_to_elastic_storage_image_reference = {
        dev = {
          publisher = "Canonical"
          offer     = "UbuntuServer"
          sku       = "16.04-LTS"
          version   = "latest"
        }
        prod = {
          publisher = "Canonical"
          offer     = "UbuntuServer"
          sku       = "16.04-LTS"
          version   = "latest"
        }
      }

      elastic_storage_os_disk         = local.env_to_elastic_storage_os_disk[terraform.workspace]
      elastic_storage_data_disk       = local.env_to_elastic_storage_data_disk[terraform.workspace]
      elastic_storage_image_reference = local.env_to_elastic_storage_image_reference[terraform.workspace]
      elastic_vm_size                 = local.env_to_elastic_vm_size[terraform.workspace]
      elastic_vm_ip_addr              = local.env_to_elastic_ip_addr[terraform.workspace]

    }
