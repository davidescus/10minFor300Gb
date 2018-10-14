#  10minutesFor300GB

### Project Requirements:   
- General
    - Cluster of apps that are able to generate 300GB of data and send them through network as http POST request 
    - Cluster able to store 300GB of data
    - Maximum time to generate, send and store less than 10 minutes
    - Infrastructure as code (Project must be able for replication with minimum effort, and project must NOT depend on cloud provider)
    - Use only open source technologies
    
- Technical:
    - Monitoring  
    - Health Check
    - Logs management (collect, aggregate)
    - Horizontal scale with minimum effort    
    
### Stack Development:
- ```machine creation:``` Terraform   
    - easy to use (one command to create, modify or destroy)    
    https://www.terraform.io/
    
- ```machine provision``` Ansible
    - based on SSH (need to learn)    
    https://www.ansible.com/
    
- ```pipelines``` ??? need to research
    - builds
    - run linters   
    - run tests on isolated environment
    - move code between stages
    
- ```monitoring``` ??? need to research
    - be sure your system is up and running
    - collect metrics
    - visualize graphs    
    
- ```for generate data``` Goland
    - easy and strait ahead programming language that deal very well with concurent and parallel use cases
    https://golang.org/
    
- ```storage``` Dgraph
    - distributed graph database
    https://dgraph.io/    
         
    

 