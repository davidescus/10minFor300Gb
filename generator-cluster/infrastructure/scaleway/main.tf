provider "scaleway" {
  organization = "${var.scw-organisation}"
  token        = "${var.scw-access-token}"
  region       = "${var.scw-region}"
}

resource "scaleway_ip" "ip-generator-300Gb" {
  count = "${var.scw-instance-number}"
  server = "${element(scaleway_server.server-generator-300Gb.*.id, count.index)}"
}

resource "scaleway_server" "server-generator-300Gb" {
  # use dynamic ip for provisioning
  # dynamic_ip_required = true
  count = "${var.scw-instance-number}"
  name  = "server-generator-300Gb-${count.index}"
  image = "${var.scw-os-image}"
  type  = "${var.scw-instance-type}"

  # ssh into machine and provision
  # provisioner "remote-exec" {
  #   inline = [
  #     "apt-get install htop",
  #   ]
  #   connection {
  #     private_key = "${file("/home/davidescus/.ssh/id_rsa_decrypted")}"
  #   }
  # }
}
