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

output "Monitoring Machine Ip: " {
  value = "${scaleway_ip.ip-monitoring.ip}"
}

# --- generator server(s) ---
resource "scaleway_ip" "ip-generator" {}
resource "scaleway_server" "server-generator" {
  name       = "server-generator"
  image      = "${var.os-image}"
  type       = "${var.instance-type}"
  public_ip  = "${scaleway_ip.ip-generator.ip}"
  depends_on = ["scaleway_ip.ip-generator", "scaleway_ip.ip-provision"]

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

output "Generator Machine Ip: " {
  value = "${scaleway_ip.ip-generator.ip}"
}
