output "node_ip" {
  value = virtualbox_vm.node[0].network_adapter[0].ipv4_address
}
