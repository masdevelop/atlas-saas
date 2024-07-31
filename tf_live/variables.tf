variable "curl_box_cmd" {
  type = string
  default = "if [ ! -f '../oslib/ubuntu-18.04-virtualbox.box' ]; then curl -L -o ../oslib/ubuntu-18.04-virtualbox.box https://app.vagrantup.com/ubuntu/boxes/bionic64/versions/20180903.0.0/providers/virtualbox.box; else echo 'File already exists, skipping download.'; fi"
}

variable "cloud-init-build-control_plane" {
  type = string
  default = "cloud-localds ../oslib/user_data_control.iso ../files/user_data_control1"
}

variable "cloud-init-build-worker1" {
  type = string
  default = "cloud-localds ../oslib/user_data_worker1.iso ../files/user_data_worker1"
}

variable "cloud-init-build-worker2" {
  type = string
  default = "cloud-localds ../oslib/user_data_worker2.iso ../files/user_data_worker2"
}

variable "control_plane" {
  type = object({
    vm_name        = string
    vm_memory      = string
    vm_cpu         = number
    vm_count       = number
    host_interface = string
    vm_user_data   = string
    vm_ip          = string
  })
  default = {
    vm_name        = "controlplane1"
    vm_memory      = "16 gib"
    vm_cpu         = 4
    vm_count       = 1
    host_interface = "vboxnet0"
    vm_user_data   = "../oslib/user_data_control.iso"
    vm_ip          = "192.168.56.10"
  }
}

variable "worker_nodes" {
  type = map(object({
    vm_name        = string
    vm_memory      = string
    vm_cpu         = number
    vm_count       = number
    host_interface = string
    vm_user_data   = string
    vm_ip          = string
  }))
  default = {
    worker1 = {
      vm_name        = "worker1"
      vm_memory      = "4.0 gib"
      vm_cpu         = 2
      vm_count       = 1
      host_interface = "vboxnet0"
      vm_user_data   = "../oslib/user_data_worker1.iso"
      vm_ip          = "192.168.56.11"
    }
    worker2 = {
      vm_name        = "worker2"
      vm_memory      = "4.0 gib"
      vm_cpu         = 2
      vm_count       = 1
      host_interface = "vboxnet0"
      vm_user_data   = "../oslib/user_data_worker2.iso"
      vm_ip          = "192.168.56.12"
    }
  }
}

variable "vm_image" {
  type    = string
  default = "../oslib/ubuntu-18.04-virtualbox.box"
}

variable "private_key_path" {
  description = "Path to the SSH private key"
  type        = string
  default     = "~/.vagrant.d/insecure_private_key"
}

variable "remote_user" {
  description = "The SSH user for the remote host"
  type        = string
  default     = "vagrant"
}
