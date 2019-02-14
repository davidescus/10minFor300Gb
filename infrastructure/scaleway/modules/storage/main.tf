variable "count-seed" {
  type = "string"
  description = "Number of servers"
}

variable "count-node" {
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
# Cassandra seed machine(s)
# ----------------------------------------------------------
resource "scaleway_ip" "cassandra-seed" {
  count = "${var.count-seed}"
  server = "${element(scaleway_server.cassandra-seed.*.id, count.index)}"
}
resource "scaleway_server" cassandra-seed {
  count = "${var.count-seed}"
  name = "cassandra-seed-${var.count-seed}"
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
      private_key = "${var.private-key}"
    }
  }
}

output "ips-cassandra-seed" {
  value = "${scaleway_ip.cassandra-seed.*.ip}"
}

# ----------------------------------------------------------
# Cassandra node machine(s)
# ----------------------------------------------------------
resource "scaleway_ip" "cassandra-node" {
  count = "${var.count-node}"
  server = "${element(scaleway_server.cassandra-node.*.id, count.index)}"
}
resource "scaleway_server" cassandra-node {
  count = "${var.count-node}"
  name = "cassandra-node_{var.count-node}"
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
      private_key = "${var.private-key}"
    }
  }
}

output "ips-cassandra-node" {
  value = "${scaleway_ip.cassandra-node.*.ip}"
}