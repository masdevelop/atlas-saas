variable "private_key_path" {
  description = "Path to the SSH private key"
  type        = string
}

variable "remote_user" {
  description = "The SSH user for the remote host"
  type        = string
}

variable "worker_nodes" {
  type = map
}

variable "api_net_advertise" {
  description = "The IP address that the API server will advertise"
  type        = string
}

variable "control_ip" {
  description = "The IP address of the control node"
  type        = string
}

variable "pod_network_cidr" {
  description = "The CIDR for the Kubernetes pod network"
  type        = string
}