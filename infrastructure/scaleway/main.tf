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
}
output "Monitoring Machine(s) Ip: " {
  value = "${module.monitoring.ips}"
}

//# ----------------------------------------------------------
//# Elasticsearch machine(s)
//# ----------------------------------------------------------
//module "elasticsearch" {
//  source = "./modules/elasticsearch"
//  count = 1
//  os-image = "${var.os-image}"
//  instance-type = "${var.instance-type}"
//  master-private-ip = "${module.provision.master-private-ip}"
//}
//output "Elasticsearch Node Machine(s) Ip: " {
//  value = "${module.elasticsearch.ips}"
//}
//
//# ----------------------------------------------------------
//# Kibana machine(s)
//# ----------------------------------------------------------
//module "kibana" {
//  source = "./modules/kibana"
//  count = 1
//  os-image = "${var.os-image}"
//  instance-type = "${var.instance-type}"
//  master-private-ip = "${module.provision.master-private-ip}"
//}
//output "Kibana Machine(s) Ip: " {
//  value = "${module.kibana.ips}"
//}
//
//# ----------------------------------------------------------
//# Logstash machine(s)
//# ----------------------------------------------------------
//module "logstash" {
//  source = "./modules/logstash"
//  count = 1
//  os-image = "${var.os-image}"
//  instance-type = "${var.instance-type}"
//  master-private-ip = "${module.provision.master-private-ip}"
//}
//output "Logstash Machine(s) Ip: " {
//  value = "${module.logstash.ips}"
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
//}
//output "Geneator Machine(s) Ip: " {
//  value = "${module.etl.ips}"
//}
//
//# ----------------------------------------------------------
//# Cassandra seed machine(s)
//# ----------------------------------------------------------
//module "cassandra-seed" {
//  source = "./modules/cassandra"
//  count = 1
//  os-image = "${var.os-image}"
//  instance-type = "${var.instance-type}"
//  master-private-ip = "${module.provision.master-private-ip}"
//  node-type = "seed"
//}
//output "Cassandra Seed Machine(s) Ip: " {
//  value = "${module.cassandra-seed.ips}"
//}
//
//# ----------------------------------------------------------
//# Cassandra node machine(s)
//# ----------------------------------------------------------
//module "cassandra-node" {
//  source = "./modules/cassandra"
//  count = 1
//  os-image = "${var.os-image}"
//  instance-type = "${var.instance-type}"
//  master-private-ip = "${module.provision.master-private-ip}"
//  node-type = "node"
//}
//output "Cassandra Node Machine(s) Ip: " {
//  value = "${module.cassandra-node.ips}"
//}
