# How to upgrade your installation
## Backup the database
From the azure portal, navigate to your SQL Azure Database and make a copy of the db  

## Run a new version of the container
Run the following script in the shell host of the machine  
(dont' forget to replace the values)
```shell
wget https://raw.githubusercontent.com/baywet/azure-docker-sonarqube/master/upgrade.sh  
chmod +x upgrade.sh
./upgrade.sh
```
_Note: The script backs up your container in case anything goes wrong as well as your currently installed plugins_
## Upgrade database Schema
Open a browser to http://urlofsonarqube/setup and upgrade the database.

## Update installed plugins
Open a browser to http://urlofsonarqube/admin/marketplace?filter=updates and update existing plugins.  

All set!

## Bonus: OS
Note: it's important to keep you system up to date
```shell
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get autoremove
```