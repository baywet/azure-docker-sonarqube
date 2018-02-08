#global configuration you have to set up
#admin of the Azure SQL "server"
dbusername=admin
#password to connect to the stabase
dbpwd=Pwd
#azure sql server name, just replace the server part
sqlserver=server.database.windows.net
#Name of the database to use, has to be created before
databasename=dbname

#don't change that
connectionString="jdbc:sqlserver://$sqlserver;databaseName=$databasename;"

#clearing existing backups of previous upgrades
rm -rf currentplugins
docker stop sonarqubebackup > /dev/null 2>&1
docker rm sonarqubebackup > /dev/null 2>&1

#copying existing plugins
docker cp sonarqube:opt/sonarqube/extensions/plugins .
mv plugins currentplugins

#stopping and renaming the container in case something goes wrong
docker stop sonarqube
docker rename sonarqube sonarqubebackup
docker update --restart=no sonarqubebackup

#upgrade image copy
docker pull sonarqube

#creating the sonarqube container and starting it
docker run -d --name sonarqube -p 9000:9000 -p 9002:9002 -e SONARQUBE_JDBC_USERNAME=$dbusername -e SONARQUBE_JDBC_PASSWORD=$dbpwd -e SONARQUBE_JDBC_URL=$connectionString  --restart=always sonarqube

#reinstalling the plugins
docker cp currentplugins/. sonarqube:/opt/sonarqube/extensions/plugins
docker restart sonarqube

#clearing old images
docker image prune -a -f