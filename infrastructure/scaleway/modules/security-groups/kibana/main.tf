resource "scaleway_security_group" "kibana" {
  name = "kibana"
  description = "Security group for kibana machine(s)"
}

resource "scaleway_security_group_rule" "kibana-accept-web" {
  security_group = "${scaleway_security_group.kibana.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 5601
}

output "id" {
  value = "${scaleway_security_group.kibana.id}"
}
