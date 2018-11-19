# auth
provider "scaleway" {
  organization = "${var.scw-organisation}"
  token        = "${var.scw-access-token}"
  region       = "${var.scw-region}"
}

# resources for provision server
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
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      // boostrap salt master on specific version (-N do not install minion)
      "sh bootstrap-salt.sh -MN stable 2017.7",
      "mkdir init-files",
      "rm /etc/salt/master",
      "mkdir /srv/salt",
    ]

    connection {
      private_key = "${file("/home/davidescus/.ssh/id_rsa_decrypted")}"
    }
  }

  # init files
  provisioner "file" {
    source = "../../provision/init-files/",
    destination = "/root/init-files/",
  }

  # salt master config
  provisioner "file" {
    source = "../../provision/overide-files/server-provision/etc/salt/master",
    destination = "/etc/salt/master",
  }

  # salt states
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

# resources for build server
resource "scaleway_ip" "ip-build" {}
resource "scaleway_server" "server-build" {
  name       = "server-build"
  image      = "${var.os-image}"
  type       = "${var.instance-type}"
  public_ip  = "${scaleway_ip.ip-build.ip}"
  depends_on = ["scaleway_ip.ip-provision"]

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "echo \"${scaleway_ip.ip-provision.ip}    salt\" >> /etc/hosts",
      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
      // boostrap salt minion (no param required)
      "sh bootstrap-salt.sh stable 2017.7",
    ]

    connection {
      private_key = "${file("/home/davidescus/.ssh/id_rsa_decrypted")}"
    }
  }
}


output "Build Machine Ip: " {
  value = "${scaleway_ip.ip-build.ip}"
}

# resources for generator
//resource "scaleway_ip" "ip-generator" {}
//resource "scaleway_server" "server-generator" {
//  name       = "server-generator"
//  image      = "${var.os-image}"
//  type       = "${var.instance-type}"
//  public_ip  = "${scaleway_ip.ip-generator.ip}"
//  depends_on = ["scaleway_ip.ip-generator", "scaleway_ip.ip-provision"]
//
//  provisioner "remote-exec" {
//    inline = [
//      "apt-get update",
//      "echo \"${scaleway_ip.ip-provision.ip}    salt\" >> /etc/hosts",
//      "wget -O bootstrap-salt.sh https://bootstrap.saltstack.com",
//      // boostrap salt minion (no param required)
//      "sh bootstrap-salt.sh stable 2017.7",
//    ]
//
//    connection {
//      private_key = "${file("/home/davidescus/.ssh/id_rsa_decrypted")}"
//    }
//  }
//}
//
//output "Generator Machine Ip: " {
//  value = "${scaleway_ip.ip-generator.ip}"
//}

// *******************************************************

// multiple instance
//resource "scaleway_ip" "ip-generator-300Gb" {
//  count = "${var.scw-instance-number}"
//  server = "${element(scaleway_server.server-generator-300Gb.*.id, count.index)}"
//}
//
//resource "scaleway_server" "server-generator-300Gb" {
//  # use dynamic ip for provisioning
//  # dynamic_ip_required = true
//  count = "${var.scw-instance-number}"
//  name  = "server-generator-300Gb-${count.index}"
//  image = "${var.scw-os-image}"
//  type  = "${var.scw-instance-type}"
//
//  // ssh into machine and provision
//  provisioner "remote-exec" {
//    inline = [
//      "apt-get install htop",
//    ]
//    connection {
//      private_key = "${file("/home/davidescus/.ssh/id_rsa_decrypted")}"
//    }
//  }
//}
