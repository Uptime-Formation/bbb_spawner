variable "hcloud_token" {}
variable "hcloud_ssh_key" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "bbb_server" {
  name  = "bbb-server"
  server_type = "cx41"
#   image = "ubuntu-16.04"
  image = "ubuntu-18.04"
#   image = "ubuntu-20.04"
  location = "nbg1"
  ssh_keys = [var.hcloud_ssh_key]
}

output "bbb_public_ip" {
  value = hcloud_server.bbb_server.ipv4_address
}