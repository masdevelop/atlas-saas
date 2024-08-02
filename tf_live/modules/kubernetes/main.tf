resource "null_resource" "control_deploy" {
  connection {
    type        = "ssh"
    host        = var.control_ip
    user        = var.remote_user
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "../scripts/control.sh"
    destination = "/tmp/control.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /tmp",
      "chmod +x control.sh",
      "./control.sh ${var.api_net_advertise} ${var.pod_network_cidr}",
      "kubeadm token create --print-join-command > /tmp/join.sh",
      "sudo cp /etc/kubernetes/admin.conf /tmp/atlas-cluster-admin-config",
      "sudo chown vagrant:vagrant /tmp/atlas-cluster-admin-config"
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.private_key_path} ${var.remote_user}@${var.control_ip}:/tmp/join.sh ../scripts/join.sh"
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.private_key_path} ${var.remote_user}@${var.control_ip}:/tmp/atlas-cluster-admin-config ../certs/atlas-cluster-admin-config"
  }

}

resource "null_resource" "worker_deploy" {
  for_each = var.worker_nodes

  connection {
    type        = "ssh"
    host        = each.value.vm_ip
    user        = var.remote_user
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "../certs/atlas-cluster-admin-config"
    destination = "/tmp/atlas-cluster-admin-config"
  }

  provisioner "file" {
    source      = "../scripts/join.sh"
    destination = "/tmp/join.sh"
  }
  
  provisioner "file" {
    source      = "../scripts/worker.sh"
    destination = "/tmp/worker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /tmp",
      "chmod +x worker.sh",
      "./worker.sh"
    ]
  }

  depends_on = [null_resource.control_deploy]
}