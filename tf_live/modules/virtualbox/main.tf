terraform {
  required_providers {
    virtualbox = {
      source  = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }
  }
}

resource "virtualbox_vm" "node" {
  count  = var.vm_count
  name   = "${var.vm_name}"
  cpus   = var.vm_cpu
  memory = var.vm_memory
  image  = var.vm_image
  optical_disks = [var.vm_user_data]
  status = "running"

  network_adapter {
    type           = "hostonly"
    host_interface = var.host_interface
  }

  network_adapter {
    type = "nat"
  }

  connection {
    type        = "ssh"
    user        = "vagrant"
    private_key = file(var.private_key_path)
    host        = self.network_adapter.0.ipv4_address
  }

  provisioner "file" {
    source      = "../scripts/common.sh"
    destination = "/tmp/common.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${var.vm_name}",
      "sudo sed -i 's/127.0.1.1 .*/127.0.1.1 ${var.vm_name}/g' /etc/hosts",
      "cd /tmp",
      "chmod +x common.sh",
      "./common.sh"
    ]
  }
}

output "vm_ip" {
  value = virtualbox_vm.node[*].network_adapter.0.ipv4_address
}
