resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.env_prefix}-${var.computer_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.env_prefix}-${var.computer_name}-nic-ip-configuration"
    subnet_id                     = var.subnet_id
    private_ip_address_version    = "IPv4"
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_ip_addr
  }
  tags = var.GLOBAL_TAGS
}

resource "azurerm_virtual_machine" "vm" {
  name                = "${var.env_prefix}-${var.computer_name}-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [
  "${azurerm_network_interface.vm_nic.id}"]
  vm_size = var.vm_size

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.storage_image_reference["publisher"]
    offer     = var.storage_image_reference["offer"]
    sku       = var.storage_image_reference["sku"]
    version   = var.storage_image_reference["version"]
  }


  storage_os_disk {
    name              = var.storage_os_disk["name"]
    caching           = var.storage_os_disk["caching"]
    create_option     = var.storage_os_disk["create_option"]
    managed_disk_type = var.storage_os_disk["managed_disk_type"]
    disk_size_gb      = var.storage_os_disk["disk_size_gb"]
  }
  os_profile {
    computer_name  = var.computer_name
    admin_username = var.admin_username
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file(var.public_ssh_key_path)
      path     = var.public_ssh_key_path_on_vm
    }
  }
  tags = var.GLOBAL_TAGS
}

resource "azurerm_managed_disk" "vm_data_disk" {
  name                 = var.storage_data_disk["name"]
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.storage_data_disk["storage_account_type"]
  create_option        = var.storage_data_disk["create_option"]
  disk_size_gb         = var.storage_data_disk["disk_size_gb"]
  tags                 = var.GLOBAL_TAGS
  count                = var.create_data_disk == "true" ? 1 : 0
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_data_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.vm_data_disk[0].id
  virtual_machine_id = azurerm_virtual_machine.vm.id
  lun                = var.storage_data_disk["lun"]
  caching            = var.storage_data_disk["caching"]
  count              = var.create_data_disk == "true" ? 1 : 0
}