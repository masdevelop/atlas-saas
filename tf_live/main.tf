provider "kubernetes" {
  config_path    = "../certs/atlas-cluster-admin-config"
  config_context = "kubernetes-admin@kubernetes"
}

module "build_isos" {
  source  = "./modules/buildiso"
  curl_box_cmd = var.curl_box_cmd
  cloud-init-build-control_plane = var.cloud-init-build-control_plane
  cloud-init-build-worker1 = var.cloud-init-build-worker1
  cloud-init-build-worker2 = var.cloud-init-build-worker2
}

module "control_plane_vbox" {
  source         = "./modules/virtualbox"
  host_interface = var.control_plane.host_interface
  private_key_path = var.private_key_path
  vm_cpu         = var.control_plane.vm_cpu
  vm_count       = var.control_plane.vm_count
  vm_image       = var.vm_image
  vm_memory      = var.control_plane.vm_memory
  vm_name        = var.control_plane.vm_name
  vm_user_data   = var.control_plane.vm_user_data

  depends_on     = [module.build_isos]
}

module "worker_vbox" {
  source         = "./modules/virtualbox"
  for_each       = var.worker_nodes
  host_interface = each.value.host_interface
  private_key_path = var.private_key_path
  vm_cpu         = each.value.vm_cpu
  vm_count       = each.value.vm_count
  vm_image       = var.vm_image
  vm_name        = each.value.vm_name
  vm_memory      = each.value.vm_memory
  vm_user_data   = each.value.vm_user_data

  depends_on     = [module.control_plane_vbox]  
}

module "kubernetes_boot" {
  source        = "./modules/kubernetes"
  worker_nodes  = var.worker_nodes
  private_key_path = var.private_key_path
  remote_user   = var.remote_user
  api_net_advertise = var.api_net_advertise
  pod_network_cidr = var.pod_network_cidr
  control_ip = var.control_ip

  depends_on    = [module.control_plane_vbox,module.worker_vbox]
}

module "kubernetes_saas" {
  source = "./modules/kubernetes_saas"

  depends_on    = [module.kubernetes_boot]
}