variable "api_net_advertise" {
  description = "The IP address that the API server will advertise"
  type        = string
}

variable "pod_network_cidr" {
  description = "The CIDR for the Kubernetes pod network"
  type        = string
}

variable "control_ip" {
  description = "The IP address of the control node"
  type        = string
}

variable "curl_box_cmd" {
  type = string
}

variable "cloud-init-build-control_plane" {
  type = string
}

variable "cloud-init-build-worker1" {
  type = string
}

variable "cloud-init-build-worker2" {
  type = string
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
}

variable "vm_image" {
  type = string
}

variable "private_key_path" {
  description = "Path to the SSH private key"
  type        = string
}

variable "remote_user" {
  description = "The SSH user for the remote host"
  type        = string
}
