resource "scaleway_security_group" "elasticsearch" {
  name = "elasticsearch"
  description = "Security group for elasticsearch machine(s)"
}

resource "scaleway_security_group_rule" "elasticsearch-accept-prometheus-node-exporter" {
  security_group = "${scaleway_security_group.elasticsearch.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9100
}

resource "scaleway_security_group_rule" "elasticsearch-accept-web" {
  security_group = "${scaleway_security_group.elasticsearch.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9200
}

resource "scaleway_security_group_rule" "elasticsearch-accept-tcp" {
  security_group = "${scaleway_security_group.elasticsearch.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9300
}

output "id" {
  value = "${scaleway_security_group.elasticsearch.id}"
}
