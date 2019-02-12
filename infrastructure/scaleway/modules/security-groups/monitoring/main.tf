resource "scaleway_security_group" "monitoring" {
  name = "provision"
  description = "Security group used for: monitoring machine(s)"
}

resource "scaleway_security_group_rule" "monitoring-accept-prometheus-web" {
  security_group = "${scaleway_security_group.monitoring.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9090
}

output "id" {
  value = "${scaleway_security_group.monitoring.id}"
}
