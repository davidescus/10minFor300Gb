resource "scaleway_security_group" "generator" {
  name = "generator"
  description = "Security group for generator machine(s)"
}

resource "scaleway_security_group_rule" "generator-accept-prometheus-node-exporter" {
  security_group = "${scaleway_security_group.generator.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9100
}

output "id" {
  value = "${scaleway_security_group.generator.id}"
}
