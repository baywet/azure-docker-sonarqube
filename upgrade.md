# How to upgrade your installation
## backup your plugins
- Login to the shell of your machine
- Run the following commands

## Backup the database
From the azure portal, navigate to your SQL Azure Database and make a copy of the db  
(the script already creates a copy of the container in case something goes wrong)

## Run a new version of the container
Run the following script in the shell host of the machine  
(dont' forget to replace the values)
```
wget https://raw.githubusercontent.com/baywet/azure-docker-sonarqube/master/upgrade.sh  
chmod +x upgrade.sh
```

## Upgrade database Schema
Open a browser to http://urlofsonarqube/setup and upgrade the database.

## Update installed plugins
Open a browser to http://urlofsonarqube/admin/marketplace?filter=updates and update existing plugins.  

All set!

## Bonus: OS
Note: it's important to keep you system up to date
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get autoremove
```