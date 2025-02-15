variable "vm_name" {
    type = string
    description = "provide the VM value"
  
}

variable "vm_size" {
    type = string
    description = "provide the vm_size"
    default = "Standard_B2s"
  
}
variable "vm_password" {
    type = string
    description = "provide the vmpassword"
    sensitive = true
  
}