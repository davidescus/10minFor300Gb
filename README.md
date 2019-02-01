#  10minutesFor300GB

### Requirements:
* Scaleway account (https://scaleway.com)
* Linux OS (tested on 18.04)
* Terraform already install (tested on 0.11.11 version)

### Description:   
- Able to generate *300GB* of random data and store them in less than *10 minutes* 
- Infrastructure as code (Project must be able for replication and deploy to new cloud provider with minimum effort
- Use only open source technologies  

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
- ```Building ingrastructure:``` Terraform   
    - easy to use (one command to create, modify or destroy)    
    https://www.terraform.io/
    
- ```Provisioning``` SaltStack
    - based on master - agents(minions)   
    https://docs.saltstack.com/en/latest/
    
- ```Monitoring``` Prometheus
    - be sure your system is up and running. Master will collect metrics from targets
    - collect metrics
    - visualize graphs  
    https://prometheus.io/    
    
- ```Logs``` ELK
    - collect logs for your`s machines
    - query logs  
    https://www.elastic.co
    
- ```Storage``` Cassandra
    - distributed database
    https://www.instaclustr.com        
    
- ```Business logic``` Golang
    - easy and strait ahead programming language that deal very well with concurent and parallel use cases
    https://golang.org/
    
### TODO's
* Develop app that satisfy business logic
* Add predefined metrics
* Implement "count" in terraform (scale apps easy)
* Add proxy to Kibana, Prometheus and other components that interact with public environment
* Remove public ips for all infrastructure
* Remove ssh access (maybe apply bastion server for direct interactions with machines)
* Add predefined indexes in Kibana
* Add support for AWS, GPC, Digital Ocean
* Setup local DNS for easy access (ex: kibana.300gbin10minutes.local will hit kibana)