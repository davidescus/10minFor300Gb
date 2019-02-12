resource "scaleway_security_group" "etl" {
  name = "etl"
  description = "Security group for etl machine(s)"
}

resource "scaleway_security_group_rule" "etl-accept-prometheus-node-exporter" {
  security_group = "${scaleway_security_group.etl.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9100
}

output "id" {
  value = "${scaleway_security_group.etl.id}"
}
