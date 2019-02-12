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

module "security-group-provision" {
  source = "../security-groups/provision"
}

resource "scaleway_ip" "ip-provision" {
  count = "${var.count}"
  server = "${element(scaleway_server.server-provision.*.id, count.index)}"
}

resource "scaleway_server" server-provision {
  count = "${var.count}"
  name = "server-provision_${var.count}"
  image = "${var.os-image}"
  type = "${var.instance-type}"
  security_group = "${module.security-group-provision.id}"
  dynamic_ip_required = true

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh -MN stable 2017.7",
      "mkdir init-files",
      "mkdir scripts",
      "rm /etc/salt/master",
      "mkdir /srv/salt",
      # TODO it does not know haw to deal with salt multimaster
      "echo \" ${self.private_ip}    salt\" >> /etc/hosts",
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${file("./without-passphrase-private-key")}"
    }
  }

  provisioner "file" {
    source = "../../scripts",
    destination = "/root",
  }

  provisioner "file" {
    source = "../../provision.sh",
    destination = "/root/provision.sh",
  }

  provisioner "file" {
    source = "../../provision-etl.sh",
    destination = "/root/provision-etl.sh",
  }
  provisioner "file" {
    source = "../../run.sh",
    destination = "/root/run.sh",
  }

  provisioner "file" {
    source = "../../overide-files/etc/salt/master",
    destination = "/etc/salt/master",
  }

  provisioner "file" {
    source = "../../overide-files/srv/",
    destination = "/srv/",
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/scripts/*",
      "chmod +x /root/provision.sh",
      "chmod +x /root/provision-etl.sh",
      "chmod +x /root/run.sh",
      "chmod 0644 /etc/salt/master",
    ]

    connection {
      private_key = "${file("./without-passphrase-private-key")}"
    }
  }
}

output "ips" {
  value = "${scaleway_ip.ip-provision.*.ip}"
}

output "master-private-ip" {
  value = "${scaleway_server.server-provision.*.private_ip[0]}"
}