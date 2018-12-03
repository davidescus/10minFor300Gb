# --- auth ---
provider "scaleway" {
  organization = "${var.scw-organisation}"
  token        = "${var.scw-access-token}"
  region       = "${var.scw-region}"
}

# --- provision server(s) ---
resource "scaleway_ip" "ip-provision" {}
resource "scaleway_server" "server-provision" {
  name       = "server-provision"
  image      = "${var.os-image}"
  type       = "${var.instance-type}"
  public_ip  = "${scaleway_ip.ip-provision.ip}"
  depends_on = ["scaleway_ip.ip-provision"]
  security_group = "${scaleway_security_group.provision.id}"

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      # install salt master
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh -MN stable 2017.7",
      "mkdir init-files",
      "rm /etc/salt/master",
      "mkdir /srv/salt",

      # install salt minion
      "echo \"${scaleway_ip.ip-provision.ip}    salt\" >> /etc/hosts",
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${file("/home/davidescus/.ssh/id_rsa_decrypted")}"
    }
  }

  provisioner "file" {
    source = "../../provision/init-files/",
    destination = "/root/init-files/",
  }

  provisioner "file" {
    source = "../../provision/overide-files/server-provision/etc/salt/master",
    destination = "/etc/salt/master",
  }

  provisioner "file" {
    source = "../../provision/overide-files/server-provision/srv/",
    destination = "/srv/",
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/init-files/*",
      "chmod 0644 /etc/salt/master",
    ]

    connection {
      private_key = "${file("/home/davidescus/.ssh/id_rsa_decrypted")}"
    }
  }
}

resource "scaleway_security_group" "provision" {
  name = "provision"
  description = "Security group for provision machines"
}

resource "scaleway_security_group_rule" "provision-accept" {
  security_group = "${scaleway_security_group.provision.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9100
}

output "Provision Machine Ip: " {
  value = "${scaleway_ip.ip-provision.ip}"
}

# --- monitor server(s)
resource "scaleway_ip" "ip-monitoring" {}
resource "scaleway_server" "server-monitoring" {
  name       = "server-monitoring"
  image      = "${var.os-image}"
  type       = "${var.instance-type}"
  public_ip  = "${scaleway_ip.ip-monitoring.ip}"
  depends_on = ["scaleway_ip.ip-monitoring", "scaleway_ip.ip-provision"]
  security_group = "${scaleway_security_group.monitoring.id}"

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "echo \"${scaleway_ip.ip-provision.ip}    salt\" >> /etc/hosts",
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${file("/home/davidescus/.ssh/id_rsa_decrypted")}"
    }
  }
}

resource "scaleway_security_group" "monitoring" {
  name = "monitoring"
  description = "Security group for monitoring machines"
}

resource "scaleway_security_group_rule" "monitoring-accept" {
  security_group = "${scaleway_security_group.monitoring.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9100
}

output "Monitoring Machine Ip: " {
  value = "${scaleway_ip.ip-monitoring.ip}"
}

# --- consul server(s) ---
resource "scaleway_ip" "ip-consul" {}
resource "scaleway_server" "server-consul" {
  name       = "server-consul"
  image      = "${var.os-image}"
  type       = "${var.instance-type}"
  public_ip  = "${scaleway_ip.ip-consul.ip}"
  depends_on = ["scaleway_ip.ip-consul", "scaleway_ip.ip-provision"]
  security_group = "${scaleway_security_group.consul.id}"

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "echo \"${scaleway_ip.ip-provision.ip}    salt\" >> /etc/hosts",
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${file("/home/davidescus/.ssh/id_rsa_decrypted")}"
    }
  }
}

resource "scaleway_security_group" "consul" {
  name = "consul"
  description = "Security group for consul"
}

resource "scaleway_security_group_rule" "consul-accept" {
  security_group = "${scaleway_security_group.consul.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9100
}

output "Consul Machine Ip: " {
  value = "${scaleway_ip.ip-consul.ip}"
}


//# --- generator server(s) ---
//resource "scaleway_ip" "ip-generator" {}
//resource "scaleway_server" "server-generator" {
//  name       = "server-generator"
//  image      = "${var.os-image}"
//  type       = "${var.instance-type}"
//  public_ip  = "${scaleway_ip.ip-generator.ip}"
//  depends_on = ["scaleway_ip.ip-generator", "scaleway_ip.ip-provision"]
//  security_group = "${scaleway_security_group.monitoring.id}"
//
//  provisioner "remote-exec" {
//    inline = [
//      "apt-get update",
//      "echo \"${scaleway_ip.ip-provision.ip}    salt\" >> /etc/hosts",
//      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
//      "sh bootstrap-salt.sh stable 2017.7",
//    ]
//
//    connection {
//      private_key = "${file("/home/davidescus/.ssh/id_rsa_decrypted")}"
//    }
//  }
//}
//
//resource "scaleway_security_group" "generator" {
//  name = "generator"
//  description = "Security group for generator machines"
//}
//
//resource "scaleway_security_group_rule" "generatot-accept" {
//  security_group = "${scaleway_security_group.generator.id}"
//  action    = "accept"
//  direction = "inbound"
//  ip_range  = "0.0.0.0/0"
//  protocol  = "TCP"
//  port      = 9100
//}
//
//output "Generator Machine Ip: " {
//  value = "${scaleway_ip.ip-generator.ip}"
//}
