resource "null_resource" "control_deploy" {
  connection {
    type        = "ssh"
    host        = "192.168.56.10"
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
      "./control.sh",
      "kubeadm token create --print-join-command > /tmp/join.sh"
    ]
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.private_key_path} ${var.remote_user}@192.168.56.10:/tmp/join.sh ../scripts/join.sh"
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

resource "null_resource" "worker_join" {
  for_each = var.worker_nodes

  connection {
    type        = "ssh"
    host        = each.value.vm_ip
    user        = var.remote_user
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "../scripts/join.sh"
    destination = "/tmp/join.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/join.sh",
      "sudo /tmp/join.sh"
    ]
  }

  depends_on = [null_resource.worker_deploy]
}