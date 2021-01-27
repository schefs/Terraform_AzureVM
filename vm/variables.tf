variable "env_prefix" {}
variable "subnet_id" {}
variable "location" {}
variable "resource_group_name" {}
variable "vm_ip_addr" {}
variable "os_disk_type" {}
variable "os_disk_size" {}
variable "data_disk_type" {}
variable "data_disk_size" {}
variable "computer_name" {}
variable "create_data_disk" {
  default = "false"
}
variable public_ssh_key_path {}
variable "admin_username" {
  default = "my_admin"
}
variable "public_ssh_key_path_on_vm" {
  default = "/home/project/.ssh/authorized_keys"
}
variable "vm_size" {}
variable "GLOBAL_TAGS" {
  type = map(string)
}
variable "storage_os_disk" {
  type = map(string)
}
variable "storage_data_disk" {
  type = map(string)
}
variable "storage_image_reference" {
  type = map(string)
}
