variable "count" {
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

resource "scaleway_ip" "monitoring" {
  count = "${var.count}"
  server = "${element(scaleway_server.monitoring.*.id, count.index)}"
}

resource "scaleway_server" monitoring {
  count = "${var.count}"
  name = "monitoring-${var.count}"
  image = "${var.os-image}"
  type = "${var.instance-type}"
  security_group = "${scaleway_security_group.monitoring.id}"
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

output "ips" {
  value = "${scaleway_ip.monitoring.*.ip}"
}
