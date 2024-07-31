resource "null_resource" "create_boots" {

  provisioner "local-exec" {
    command = var.curl_box_cmd
  }

  provisioner "local-exec" {
    command = var.cloud-init-build-control_plane
  }
  
   provisioner "local-exec" {
     command = var.cloud-init-build-worker1
   }
  
   provisioner "local-exec" {
     command = var.cloud-init-build-worker2
   }
 } 
