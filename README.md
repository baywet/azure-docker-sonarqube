# azure-docker-sonarqube
The purpose of this repo is to get you up and running with sonarqube in azure in less than an hour

## required resources
- Azure subscription
- [Putty](http://www.putty.org/)

## step 1 create the virtual machine in azure
Please refer to the [following documentation](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-quick-create-portal/) to create a ubuntu server 16 virutal machine in Azure.
Write down the FQDN of the machine.

## step 2 opening firewall ports
Please refer to the [following documentation](https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-windows-nsg-quickstart-portal/) and open ports 9000, 443, 22 and 80.

## step 3 create the Azure SQL database
Please refer to the [following documentation](https://azure.microsoft.com/en-us/documentation/articles/sql-database-get-started/) to create an Azure SQL database.
Write down the database name, Azure SQL Server FQDN, username and password.

## step 4 setup docker
Please refer to the [following documentation](https://docs.docker.com/engine/installation/linux/ubuntulinux/) to install docker on your machine.  
If you want to go faster to install docker you can simply run :  
```
wget https://raw.githubusercontent.com/baywet/azure-docker-sonarqube/master/dockerfastinstall.sh  
chmod +x dockerfastinstall.sh
./dockerfastinstall.sh
``` 
Note: in both cases don't forget to log in and out from the machine before going to step 5.  
## step 5 configure all containers
From the bash run  
```
wget https://raw.githubusercontent.com/baywet/azure-docker-sonarqube/master/step1.sh`  
chmod +x step1.sh
```
Then edit the script using vi to set up your configuration values.  
Then run  
``` 
./step1.sh
```
Note: the first load time might time out or take a while

## step 6 configure authentication
Please refer to the [following documentation](https://github.com/SonarQubeCommunity/sonar-auth-aad) to configure authentication using Azure Active Directory

## Step 7 configure your first project with VSTS
Please refer to the [following documentation](http://docs.sonarqube.org/display/SCAN/From+Team+Foundation+Server+2015+or+Visual+Studio+Team+Services) to configure your first project analysis on VSTS
