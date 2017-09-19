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

#creating the sonarqube container and starting it
docker run -d --name sonarqube -p 9000:9000 -p 9002:9002 -e SONARQUBE_JDBC_USERNAME=$dbusername -e SONARQUBE_JDBC_PASSWORD=$dbpwd -e SONARQUBE_JDBC_URL=$connectionString  --restart=always sonarqube
