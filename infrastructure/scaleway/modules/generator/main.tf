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

module "security-group-generator" {
  source = "../security-groups/generator"
}

resource "scaleway_ip" "ip-generator" {
  count = "${var.count}"
  server = "${element(scaleway_server.server-generator.*.id, count.index)}"
}

resource "scaleway_server" server-generator {
  count = "${var.count}"
  name = "server-generator_${var.count}"
  image = "${var.os-image}"
  type = "${var.instance-type}"
  security_group = "${module.security-group-generator.id}"
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
  value = "${scaleway_ip.ip-generator.*.ip}"
}
