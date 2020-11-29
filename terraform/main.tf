variable "hcloud_token" {}
variable "hcloud_ssh_key" {}

variable "ovh_application_key" {}
variable "ovh_application_secret" {}
variable "ovh_consumer_key" {}

module "servers" {
  source = "./servers_providers/hcloud"

  hcloud_token = var.hcloud_token
  hcloud_ssh_key = var.hcloud_ssh_key
 }


module "domains" {
  source                    = "./domains_providers/ovh"
  ovh_application_key       = var.ovh_application_key
  ovh_application_secret    = var.ovh_application_secret
  ovh_consumer_key          = var.ovh_consumer_key
  bbb_public_ip       = module.servers.bbb_public_ip
}

# module "domains" {
#   source                    = "./domains_providers/digital_ocean"
#   digitalocean_token        = var.digitalocean_token
# }
