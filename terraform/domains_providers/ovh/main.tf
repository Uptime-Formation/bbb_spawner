variable "ovh_application_key" {}
variable "ovh_application_secret" {}
variable "ovh_consumer_key" {}

variable "bbb_public_ip" {}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key

}

data "ovh_domain_zone" "ethicaltech_domain" {
  name = "ethicaltech.best"
}

resource "ovh_domain_zone_record" "bbb_subdomain" {
  zone      = data.ovh_domain_zone.ethicaltech_domain.name
  subdomain = "bbb"
  fieldtype = "A"
  ttl       = "0"
  target    = var.bbb_public_ip
}

output "bbb_domain" {
  value = "${ovh_domain_zone_record.bbb_subdomain.subdomain}.${ovh_domain_zone_record.bbb_subdomain.zone}"
}