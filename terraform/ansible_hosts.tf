## Ansible mirroring hosts section
# Using https://github.com/nbering/terraform-provider-ansible/ to be installed manually (third party provider)
# Copy binary to ~/.terraform.d/plugins/


resource "ansible_host" "ansible_bbb_server" {
  inventory_hostname = "bbb-server"
  groups = ["all", "hetzner", "bbb_servers"]
  vars = {
    ansible_python_interpreter = "/usr/bin/python3"
    ansible_host = module.servers.bbb_public_ip
    bbb_domain = module.domains.bbb_domain
  }
}
