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

variable "node-type" {
  type = "string"
  description = "Node type seed/normal-node"
}

resource "scaleway_ip" "cassandra" {
  count = "${var.count}"
  server = "${element(scaleway_server.cassandra.*.id, count.index)}"
}

resource "scaleway_server" cassandra {
  count = "${var.count}"
  name = "cassandra-${var.node-type}_${var.count}"
  image = "${var.os-image}"
  type = "${var.instance-type}"
  dynamic_ip_required = true

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "echo \"${var.master-private-ip}    salt\" >> /etc/hosts",
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${file("./without-passphrase-private-key")}"
    }
  }
}

output "ips" {
  value = "${scaleway_ip.cassandra.*.ip}"
}
