api_net_advertise = "192.168.56.10"
pod_network_cidr  = "172.16.1.0/16"
control_ip = "192.168.56.10"

curl_box_cmd = "if [ ! -f '../oslib/ubuntu-18.04-virtualbox.box' ]; then curl -L -o ../oslib/ubuntu-18.04-virtualbox.box https://app.vagrantup.com/ubuntu/boxes/bionic64/versions/20180903.0.0/providers/virtualbox.box; else echo 'File already exists, skipping download.'; fi"

cloud-init-build-control_plane = "cloud-localds ../oslib/user_data_control.iso ../files/user_data_control1"

cloud-init-build-worker1 = "cloud-localds ../oslib/user_data_worker1.iso ../files/user_data_worker1"

cloud-init-build-worker2 = "cloud-localds ../oslib/user_data_worker2.iso ../files/user_data_worker2"

control_plane = {
  vm_name        = "controlplane1"
  vm_memory      = "16 gib"
  vm_cpu         = 4
  vm_count       = 1
  host_interface = "vboxnet0"
  vm_user_data   = "../oslib/user_data_control.iso"
  vm_ip          = "192.168.56.10"
}

worker_nodes = {
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

vm_image = "../oslib/ubuntu-18.04-virtualbox.box"

private_key_path = "../certs/insecure_private_key"

remote_user = "vagrant"
