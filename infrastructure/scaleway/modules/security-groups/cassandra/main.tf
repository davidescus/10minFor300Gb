resource "scaleway_security_group" "cassandra" {
  name = "cassandra"
  description = "Security group for cassandra machine(s)"
}

resource "scaleway_security_group_rule" "cassandra-accept-prometheus-node-exporter" {
  security_group = "${scaleway_security_group.cassandra.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9100
}

output "id" {
  value = "${scaleway_security_group.cassandra.id}"
}
