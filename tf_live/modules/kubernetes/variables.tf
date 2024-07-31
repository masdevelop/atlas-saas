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