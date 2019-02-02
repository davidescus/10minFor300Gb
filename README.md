#  10minutesFor300GB

### Description:   
- Able to generate *300GB* of random data and store them in less than *10 minutes* 
- Infrastructure as code 
- Horizontal scale   
- Implement new cloud provider with minimum effort
- Use only open source technologies  

### Requirements:
* Scaleway account (https://scaleway.com)
* Linux OS (tested on 18.04)
* Terraform already install (tested on 0.11.11 version)

### How it works:
``` cd infrastructure/scaleway/
    mv without-passphrase-private-key.example without-passphrase-private-key (your private key without passphrase)    
    mv secret.tf.example secret.tf
```    
Add your private key (your key must does not have passphrase) used for scaleway into "without-passphrase-private-key"
Add your scaleway "organisation id" and "access-token" into secret.tf

```$xslt
terraform plan
terraform apply
ssh root@{server-provision ip}
./provision.sh
salt '*' state.apply
```

This is it! 

### Modules:
* Generator
* Application (Business logic)
* Storage
* Monitoring
* Logging

### Stack:
- ```Building ingrastructure:``` *Terraform* (https://www.terraform.io/)   
    - create, modify, destroy infrastructure    
   
- ```Provisioning``` *SaltStack* (https://docs.saltstack.com/en/latest/)
    - provision infrastructure
    
- ```Monitoring``` *Prometheus* (https://prometheus.io/) 
    - collect, visualize metrics
    
- ```Logs``` *ELK* (https://www.elastic.co)
    - collect, aggregate, query logs from all machines
     
- ```Storage``` *Cassandra* (https://www.instaclustr.com)
    - distributed database         
    
- ```Business logic``` *Golang* (https://golang.org/)
    - easy and strait ahead programming language that deal very well with concurrent and parallel use cases
    
### TODO's
* Develop app that satisfy business logic
* Setup local DNS for easy access (ex: kibana.10minutesFor300Gb.local will hit kibana)
* Implement "count" in terraform (scale apps easy)
* Add predefined metrics in prometheus
* Add predefined indexes in Kibana
* Add proxy to Kibana, Prometheus and other components that interact with public environment
* Remove public ips for all infrastructure
* Remove ssh access (maybe apply bastion server for direct interactions with machines)
* Add support for AWS, GPC, Digital Ocean
