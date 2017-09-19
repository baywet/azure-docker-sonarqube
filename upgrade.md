# How to upgrade your installation
## backup your plugins
- Login to the shell of your machine
- Run the following commands
```
mkdir currentplugins
docker cp sonarqube:opt/sonarqube/extensions/plugins currentplugins
```

## Archive the current container
```
docker stop sonarqube
docker rename sonarqube sonarqubebackup
```

## Upgrade image copy
```
docker pull sonarqube
```

## Backup the database
From the azure portal, navigate to your SQL Azure Database and make a copy of the db

## Run a new version of the container
Run the following script in the shell host of the machine  
(dont' forget to replace the values)
```
wget https://raw.githubusercontent.com/baywet/azure-docker-sonarqube/master/upgrade.sh`  
chmod +x upgrade.sh
```

## Restore the plugins you want
From the shell copy the plugins you want with that command
```
docker cp currentplugins/plugins/somepluginname sonarqube:opt/sonarqube/extensions/plugins
```

## Upgrade database Schema
Open a browser to http://urlofsonarqube/setup and upgrade the database.

## Cleanup
- Delete the copy of the database in Azure
- Run the following commands
```
rm -rf currentplugins
docker rm sonarqubebackup
```

All set!

## Bonus: OS
Note: it's important to keep you system up to date
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get autoremove
```