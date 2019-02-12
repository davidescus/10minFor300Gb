resource "scaleway_security_group" "logstash" {
  name = "logstash"
  description = "Security group for logstash machine(s)"
}

resource "scaleway_security_group_rule" "logstash-accept-beats" {
  security_group = "${scaleway_security_group.logstash.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 5044
}

output "id" {
  value = "${scaleway_security_group.logstash.id}"
}
