variable "count-elasticsearch" {
  type = "string"
  description = "Number of servers"
}

variable "count-kibana" {
  type = "string"
  description = "Number of servers"
}

variable "count-logstash" {
  type = "string"
  description = "Number of servers"
}

variable "os-image" {
  type = "string"
  description = "OS image"
}

variable "instance-type" {
  type = "string"
  description = "Server Type"
}

variable "master-private-ip" {
  type = "string"
  description = "Ip of provision master machine"
}

variable "private-key" {
  type = "string"
  description = "Private key for ssh connection"
}

# ----------------------------------------------------------
# Elasticsearch machine(s)
# ----------------------------------------------------------
resource "scaleway_ip" "elasticsearch" {
  count = "${var.count-elasticsearch}"
  server = "${element(scaleway_server.elasticsearch.*.id, count.index)}"
}

resource "scaleway_server" elasticsearch {
  count = "${var.count-elasticsearch}"
  name = "elasticsearch_${var.count-elasticsearch}"
  image = "${var.os-image}"
  type = "${var.instance-type}"
  security_group = "${scaleway_security_group.elasticsearch.id}"
  dynamic_ip_required = true

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "echo \"${var.master-private-ip}    salt\" >> /etc/hosts",
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${var.private-key}"
    }
  }
}

resource "scaleway_security_group" "elasticsearch" {
  name = "elasticsearch"
  description = "Security group for elasticsearch machine(s)"
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

output "ips-elasticsearch" {
  value = "${scaleway_ip.elasticsearch.*.ip}"
}

# ----------------------------------------------------------
# Kibana machine(s)
# ----------------------------------------------------------
resource "scaleway_ip" "kibana" {
  count = "${var.count-kibana}"
  server = "${element(scaleway_server.kibana.*.id, count.index)}"
}

resource "scaleway_server" kibana {
  count = "${var.count-kibana}"
  name = "kibana_${var.count-kibana}"
  image = "${var.os-image}"
  type = "${var.instance-type}"
  security_group = "${scaleway_security_group.kibana.id}"
  dynamic_ip_required = true

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "echo \"${var.master-private-ip}    salt\" >> /etc/hosts",
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${var.private-key}"
    }
  }
}

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

output "ips-kibana" {
  value = "${scaleway_ip.kibana.*.ip}"
}

# ----------------------------------------------------------
# Logstash machine(s)
# ----------------------------------------------------------
resource "scaleway_ip" "logstash" {
  count = "${var.count-logstash}"
  server = "${element(scaleway_server.logstash.*.id, count.index)}"
}
resource "scaleway_server" logstash {
  count = "${var.count-logstash}"
  name = "logstash_${var.count-logstash}"
  image = "${var.os-image}"
  type = "${var.instance-type}"
  security_group = "${scaleway_security_group.logstash.id}"
  dynamic_ip_required = true

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "echo \"${var.master-private-ip}    salt\" >> /etc/hosts",
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${var.private-key}"
    }
  }
}

// TODO check if it is required this security groups
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

output "ips-logstash" {
  value = "${scaleway_ip.logstash.*.ip}"
}
