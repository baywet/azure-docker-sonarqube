# azure-docker-sonarqube
The purpose of this repo is to get you up and running with sonarqube in azure in less than an hour

## please don't use it yet, it's not ready

##TODO's
- document setup
- document post steps ( https://github.com/SonarQubeCommunity/sonar-auth-aad)

##required resources
- Azure subscription
- [Putty](http://www.putty.org/)

##Step 1 create the virtual machine in azure
Please refer to the [following documentation](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-quick-create-portal/) to create a ubuntu server 16 virutal machine in Azure.
Write down the FQDN of the machine.

##step 2 opening firewall ports
Please refer to the [following documentation](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-nsg-quickstart-portal/) and open ports 9000, 443, 22 and 80.

##step 3 create the Azure SQL database
Please refer to the [following documentation](https://azure.microsoft.com/en-us/documentation/articles/sql-database-get-started/) to create an Azure SQL database.
Write down the database name, Azure SQL Server FQDN, username and password.

##step 4 setup docker
Please refer to the [following documentation](https://docs.docker.com/engine/installation/linux/ubuntulinux/) to install docker on your 
