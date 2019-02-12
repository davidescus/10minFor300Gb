resource "scaleway_security_group" "provision" {
  name = "provision"
  description = "Security group used for: provision machine(s)"
}

resource "scaleway_security_group_rule" "accept-prometheus" {
  security_group = "${scaleway_security_group.provision.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9100
}

output "id" {
  value = "${scaleway_security_group.provision.id}"
}
