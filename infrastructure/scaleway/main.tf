# ----------------------------------------------------------
# Scaleway Auth
# ----------------------------------------------------------
provider "scaleway" {
  organization = "${var.scw-organisation}"
  token = "${var.scw-access-token}"
  region = "${var.scw-region}"
}

# ----------------------------------------------------------
# Provision(bastion) machine(s)
# TODO count must be 1 (it does not know haw to deal with salt multimaster)
# ----------------------------------------------------------
module "provision" {
  source = "./modules/provision"
  count = 1
  os-image = "${var.os-image}"
  instance-type = "${var.instance-type}"
  private-key = "${file(var.private-key)}"
}
output "Provision Machine(s) Ip: " {
  value = "${module.provision.ips}"
}

# ----------------------------------------------------------
# Monitoring machine(s)
# ----------------------------------------------------------
module "monitoring" {
  source = "./modules/monitoring"
  count = 1
  os-image = "${var.os-image}"
  instance-type = "${var.instance-type}"
  master-private-ip = "${module.provision.master-private-ip}"
  private-key = "${file(var.private-key)}"
}
output "Monitoring Machine(s) Ip: " {
  value = "${module.monitoring.ips}"
}

# ----------------------------------------------------------
# Logging machine(s)
# ----------------------------------------------------------
module "logging" {
  source = "./modules/logging"
  count-elasticsearch = 1
  count-kibana = 1
  count-logstash = 1
  os-image = "${var.os-image}"
  instance-type = "${var.instance-type}"
  master-private-ip = "${module.provision.master-private-ip}"
  private-key = "${file(var.private-key)}"
}
output "Elasticsearch Machine(s) Ip: " {
  value = "${module.logging.ips-elasticsearch}"
}
output "Kibana Machine(s) Ip: " {
  value = "${module.logging.ips-kibana}"
}
output "Logstash Machine(s) Ip: " {
  value = "${module.logging.ips-logstash}"
}

//# ----------------------------------------------------------
//# Cassandra seed machine(s)
//# ----------------------------------------------------------
//module "storage" {
//  source = "./modules/storage"
//  count-seed = 1
//  count-node = 1
//  os-image = "${var.os-image}"
//  instance-type = "${var.instance-type}"
//  master-private-ip = "${module.provision.master-private-ip}"
//  private-key = "${file(var.private-key)}"
//}
//output "Cassandra Seed Machine(s) Ip: " {
//  value = "${module.storage.ips-cassandra-seed}"
//}
//output "Cassandra Node Machine(s) Ip: " {
//  value = "${module.storage.ips-cassandra-node}"
//}
//
//# ----------------------------------------------------------
//# Etl machine(s)
//# ----------------------------------------------------------
//module "etl" {
//  source = "./modules/etl"
//  count = 1
//  os-image = "${var.os-image}"
//  instance-type = "${var.instance-type}"
//  master-private-ip = "${module.provision.master-private-ip}"
//  private-key = "${file(var.private-key)}"
//}
//output "Etl Machine(s) Ip: " {
//  value = "${module.etl.ips}"
//}
//
//# ----------------------------------------------------------
//# Geneator machine(s)
//# ----------------------------------------------------------
//module "generator" {
//  source = "./modules/generator"
//  count = 1
//  os-image = "${var.os-image}"
//  instance-type = "${var.instance-type}"
//  master-private-ip = "${module.provision.master-private-ip}"
//  private-key = "${file(var.private-key)}"
//}
//output "Geneator Machine(s) Ip: " {
//  value = "${module.etl.ips}"
//}
