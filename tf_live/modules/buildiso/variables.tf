variable "curl_box_cmd" {
  description = "The host interface for the VM network."
  type        = string
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
