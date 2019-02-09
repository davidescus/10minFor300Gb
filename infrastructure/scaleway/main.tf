# --- auth ---
provider "scaleway" {
  organization = "${var.scw-organisation}"
  token        = "${var.scw-access-token}"
  region       = "${var.scw-region}"
}

# --- provision server(s) ---
# TODO scale to multiple machines if necesary
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
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh -MN stable 2017.7",
      "mkdir init-files",
      "mkdir scripts",
      "rm /etc/salt/master",
      "mkdir /srv/salt",
      "echo \"${scaleway_ip.ip-provision.ip}    salt\" >> /etc/hosts",
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${file("./without-passphrase-private-key")}"
    }
  }

  provisioner "file" {
    source = "../../scripts/",
    destination = "/root/scripts/",
  }

  provisioner "file" {
    source = "../../provision.sh",
    destination = "/root/provision.sh",
  }

  provisioner "file" {
    source = "../../provision-app.sh",
    destination = "/root/provision-app.sh",
  }
  provisioner "file" {
    source = "../../start-app.sh",
    destination = "/root/start-app.sh",
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
      "chmod +x /root/provision-app.sh",
      "chmod +x /root/start-app.sh",
      "chmod 0644 /etc/salt/master",
    ]

    connection {
      private_key = "${file("./without-passphrase-private-key")}"
    }
  }
}

resource "scaleway_security_group" "provision" {
  name = "provision"
  description = "Security group for provision machines"
}

resource "scaleway_security_group_rule" "provision-accept-prometheus-node-exporter" {
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

//# --- monitor server(s)
//# TODO scale to multiple machines
//resource "scaleway_ip" "ip-monitoring" {}
//resource "scaleway_server" "server-monitoring" {
//  name       = "server-monitoring"
//  image      = "${var.os-image}"
//  type       = "${var.instance-type}"
//  public_ip  = "${scaleway_ip.ip-monitoring.ip}"
//  depends_on = ["scaleway_ip.ip-monitoring", "scaleway_ip.ip-provision"]
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
//      private_key = "${file("./without-passphrase-private-key")}"
//    }
//  }
//}
//
//resource "scaleway_security_group" "monitoring" {
//  name = "monitoring"
//  description = "Security group for monitoring machines"
//}
//
//resource "scaleway_security_group_rule" "monitoring-accept-prometheus-node-exporter" {
//  security_group = "${scaleway_security_group.monitoring.id}"
//  action    = "accept"
//  direction = "inbound"
//  ip_range  = "0.0.0.0/0"
//  protocol  = "TCP"
//  port      = 9100
//}
//
//resource "scaleway_security_group_rule" "monitoring-accept-prometheus-web" {
//  security_group = "${scaleway_security_group.monitoring.id}"
//  action    = "accept"
//  direction = "inbound"
//  ip_range  = "0.0.0.0/0"
//  protocol  = "TCP"
//  port      = 9090
//}
//
//output "Monitoring Machine Ip: " {
//  value = "${scaleway_ip.ip-monitoring.ip}"
//}
//
//# --- elasticserach server(s)
//# TODO scale to multiple machines
//resource "scaleway_ip" "ip-elasticsearch" {}
//resource "scaleway_server" "server-elasticsearch" {
//  name       = "server-elasticsearch"
//  image      = "${var.os-image}"
//  type       = "${var.instance-type}"
//  public_ip  = "${scaleway_ip.ip-elasticsearch.ip}"
//  depends_on = ["scaleway_ip.ip-provision"]
//  security_group = "${scaleway_security_group.elasticsearch.id}"
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
//      private_key = "${file("./without-passphrase-private-key")}"
//    }
//  }
//}
//
//resource "scaleway_security_group" "elasticsearch" {
//  name = "elasticsearch"
//  description = "Security group for elasticsearch machines"
//}
//
//resource "scaleway_security_group_rule" "elasticsearch-accept-prometheus-node-exporter" {
//  security_group = "${scaleway_security_group.elasticsearch.id}"
//  action    = "accept"
//  direction = "inbound"
//  ip_range  = "0.0.0.0/0"
//  protocol  = "TCP"
//  port      = 9100
//}
//
//resource "scaleway_security_group_rule" "elasticsearch-accept-web" {
//  security_group = "${scaleway_security_group.elasticsearch.id}"
//  action    = "accept"
//  direction = "inbound"
//  ip_range  = "0.0.0.0/0"
//  protocol  = "TCP"
//  port      = 9200
//}
//
//resource "scaleway_security_group_rule" "elasticsearch-accept-tcp" {
//  security_group = "${scaleway_security_group.elasticsearch.id}"
//  action    = "accept"
//  direction = "inbound"
//  ip_range  = "0.0.0.0/0"
//  protocol  = "TCP"
//  port      = 9300
//}
//
//output "Elasticsearch Machine Ip: " {
//  value = "${scaleway_ip.ip-elasticsearch.ip}"
//}
//
//# --- kibana server(s) ---
//# TODO scale to multiple machines
//resource "scaleway_ip" "ip-kibana" {}
//resource "scaleway_server" "server-kibana" {
//  name       = "server-kibana"
//  image      = "${var.os-image}"
//  type       = "${var.instance-type}"
//  public_ip  = "${scaleway_ip.ip-kibana.ip}"
//  depends_on = ["scaleway_ip.ip-provision"]
//  security_group = "${scaleway_security_group.kibana.id}"
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
//      private_key = "${file("./without-passphrase-private-key")}"
//    }
//  }
//}
//
//resource "scaleway_security_group" "kibana" {
//  name = "kibana"
//  description = "Security group for kibana machines"
//}
//
//resource "scaleway_security_group_rule" "kibana-accept-prometheus-node-exporter" {
//  security_group = "${scaleway_security_group.kibana.id}"
//  action    = "accept"
//  direction = "inbound"
//  ip_range  = "0.0.0.0/0"
//  protocol  = "TCP"
//  port      = 9100
//}
//
//resource "scaleway_security_group_rule" "kibana-accept-web" {
//  security_group = "${scaleway_security_group.kibana.id}"
//  action    = "accept"
//  direction = "inbound"
//  ip_range  = "0.0.0.0/0"
//  protocol  = "TCP"
//  port      = 5601
//}
//
//output "Kibana Machine Ip: " {
//  value = "${scaleway_ip.ip-kibana.ip}"
//}
//
//# --- logstash server(s) ---
//# TODO scale to multiple machines
//resource "scaleway_ip" "ip-logstash" {}
//resource "scaleway_server" "server-logstash" {
//  name       = "server-logstash"
//  image      = "${var.os-image}"
//  type       = "${var.instance-type}"
//  public_ip  = "${scaleway_ip.ip-logstash.ip}"
//  depends_on = ["scaleway_ip.ip-provision"]
//  security_group = "${scaleway_security_group.logstash.id}"
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
//      private_key = "${file("./without-passphrase-private-key")}"
//    }
//  }
//}
//
//resource "scaleway_security_group" "logstash" {
//  name = "logstash"
//  description = "Security group for logstash machines"
//}
//
//resource "scaleway_security_group_rule" "logstash-accept-prometheus-node-exporter" {
//  security_group = "${scaleway_security_group.logstash.id}"
//  action    = "accept"
//  direction = "inbound"
//  ip_range  = "0.0.0.0/0"
//  protocol  = "TCP"
//  port      = 9100
//}
//
//resource "scaleway_security_group_rule" "logstash-accept-beats" {
//  security_group = "${scaleway_security_group.logstash.id}"
//  action    = "accept"
//  direction = "inbound"
//  ip_range  = "0.0.0.0/0"
//  protocol  = "TCP"
//  port      = 5044
//}
//
//output "Logstash Machine Ip: " {
//  value = "${scaleway_ip.ip-logstash.ip}"
//}

# --- application node server(s) ---
# TODO scale to multiple machines
resource "scaleway_ip" "ip-generator" {}
resource "scaleway_server" "server-generator" {
  name       = "server-generator"
  image      = "${var.os-image}"
  type       = "${var.instance-type}"
  public_ip  = "${scaleway_ip.ip-generator.ip}"
  depends_on = ["scaleway_ip.ip-provision"]
  security_group = "${scaleway_security_group.generator.id}"

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "echo \"${scaleway_ip.ip-provision.ip}    salt\" >> /etc/hosts",
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${file("./without-passphrase-private-key")}"
    }
  }
}

resource "scaleway_security_group" "generator" {
  name = "application"
  description = "Security group for generator machines"
}

resource "scaleway_security_group_rule" "generator-accept-prometheus-node-exporter" {
  security_group = "${scaleway_security_group.generator.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9100
}

output "Generator Machine Ip: " {
  value = "${scaleway_ip.ip-generator.ip}"
}

# --- application node server(s) ---
# TODO scale to multiple machines
resource "scaleway_ip" "ip-application" {}
resource "scaleway_server" "server-application" {
  name       = "server-application"
  image      = "${var.os-image}"
  type       = "${var.instance-type}"
  public_ip  = "${scaleway_ip.ip-application.ip}"
  depends_on = ["scaleway_ip.ip-provision"]
  security_group = "${scaleway_security_group.application.id}"

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "echo \"${scaleway_ip.ip-provision.ip}    salt\" >> /etc/hosts",
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${file("./without-passphrase-private-key")}"
    }
  }
}

resource "scaleway_security_group" "application" {
  name = "application"
  description = "Security group for application machines"
}

resource "scaleway_security_group_rule" "application-accept-prometheus-node-exporter" {
  security_group = "${scaleway_security_group.application.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9100
}

output "Application Machine Ip: " {
  value = "${scaleway_ip.ip-application.ip}"
}

# --- cassandra seed server(s) ---
# TODO scale to multiple machines
resource "scaleway_ip" "ip-cassandra-seed" {}
resource "scaleway_server" "server-cassandra-seed" {
  name       = "server-cassandra-seed"
  image      = "${var.os-image}"
  type       = "${var.instance-type}"
  public_ip  = "${scaleway_ip.ip-cassandra-seed.ip}"
  depends_on = ["scaleway_ip.ip-cassandra-seed"]
  security_group = "${scaleway_security_group.cassandra-seed.id}"

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "echo \"${scaleway_ip.ip-provision.ip}    salt\" >> /etc/hosts",
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${file("./without-passphrase-private-key")}"
    }
  }
}

resource "scaleway_security_group" "cassandra-seed" {
  name = "cassandra-seed"
  description = "Security group for cassandra seed machines"
}

resource "scaleway_security_group_rule" "cassandra-seed-accept-prometheus-node-exporter" {
  security_group = "${scaleway_security_group.cassandra-seed.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9100
}

output "Cassandra Seed Machine Ip: " {
  value = "${scaleway_ip.ip-cassandra-seed.ip}"
}

# --- cassandra node server(s) ---
# TODO scale to multiple machines
resource "scaleway_ip" "ip-cassandra-node" {}
resource "scaleway_server" "server-cassandra-node" {
  name       = "server-cassandra-node"
  image      = "${var.os-image}"
  type       = "${var.instance-type}"
  public_ip  = "${scaleway_ip.ip-cassandra-node.ip}"
  depends_on = ["scaleway_ip.ip-cassandra-node"]
  security_group = "${scaleway_security_group.cassandra-node.id}"

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "echo \"${scaleway_ip.ip-provision.ip}    salt\" >> /etc/hosts",
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${file("./without-passphrase-private-key")}"
    }
  }
}

resource "scaleway_security_group" "cassandra-node" {
  name = "cassandra-node"
  description = "Security group for cassandra machines"
}

resource "scaleway_security_group_rule" "cassandra-node-accept-prometheus-node-exporter" {
  security_group = "${scaleway_security_group.cassandra-node.id}"
  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
  port      = 9100
}

output "Cassandra Node Machine Ip: " {
  value = "${scaleway_ip.ip-cassandra-node.ip}"
}
