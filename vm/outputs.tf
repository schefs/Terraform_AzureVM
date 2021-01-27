# ---------------------------- Global tags used accross all items ----------------------------
output GLOBAL_TAGS {
  value = var.GLOBAL_TAGS
}
output "vm_id" {
  value = azurerm_virtual_machine.vm.id
}
