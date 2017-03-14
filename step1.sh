#global configuration you have to set up
#admin of the Azure SQL "server"
dbusername=admin@server
#password to connect to the stabase
dbpwd=Pwd
#azure sql server name, just replace the server part
sqlserver=server.database.windows.net
#Name of the database to use, has to be created before
databasename=dbname
#domain name for the machine that the users will use to connect to it
hostname=machinefqdn
#name of your company
organization=companyname
#division sonarqube is being provisionned for
ounit=division
#country of your company in the form of a two character ISO code
country=CA
#name of the city of your company
location=cityname
#state of the company, if you're located in a company with no states, just enter the name of the company again
state=state
#email of the administrator of sonarqube machine
email=email@domain.com

#don't change that
connectionString="jdbc:sqlserver://$sqlserver;databaseName=$databasename;"


#opening ports on the firewall and starting the firewall
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 9000
sudo ufw allow 9002
sudo systemctl start ufw
sudo systemctl enable ufw

#creating the sonarqube container and starting it
docker run -d --name sonarqube -p 9000:9000 -p 9002:9002 -e SONARQUBE_JDBC_USERNAME=$dbusername -e SONARQUBE_JDBC_PASSWORD=$dbpwd -e SONARQUBE_JDBC_URL=$connectionString  --restart=always sonarqube

#creating the ssl certificats for https reverse proxy
sudo openssl req -new -nodes -subj "/C=$country/ST=$state/L=$location/O=$organization/OU=$ounit/CN=$hostname/emailAddress=$email" > $hostname.crt
mv privkey.pem $hostname.pem
sudo openssl rsa -in $hostname.pem -out $hostname.key
sudo openssl x509 -in $hostname.crt -out $hostname.cert.cert -req -signkey $hostname.key -days 365
sudo cp $hostname.cert.cert /etc/ssl/certs/$hostname.crt
sudo cp $hostname.key /etc/ssl/private/$hostname.key

#creating a dummy nginx machine to copy the config file and destorying it
docker run --name nginx -d nginx
docker cp nginx:/etc/nginx/nginx.conf .
docker stop nginx
docker rm nginx

#configuring the reverse proxy
sed -i "s/\(listen\s*80;\)/\1\n\tlisten 443 ssl;\n\tlisten [::]:443 ssl;\n\tclient_max_body_size 64M;\n\tssl_certificate \/etc\/ssl\/certs\/$hostname.crt;\n\tssl_certificate_key \/etc\/ssl\/private\/$hostname.key;/" ./nginx.conf
sed -i "s/server_name\s*localhost;/server_name  $hostname;/" ./nginx.conf
sed -i '15d;17,48d' ./nginx.conf
sqip=$(docker inspect sonarqube | grep IPAddress | sed '1d;3d;' | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
sed -i "s/root.*;/proxy_pass http:\/\/$sqip:9000;\n\tproxy_set_header X-Real-IP \$remote_addr;\n\tproxy_set_header X-Forwarded-For \$remote_addr;\n\tproxy_set_header Host \$host;/" ./nginx.conf

#moving the nginx config file to the right place
sudo mkdir /var/sitesconf
sudo mv ./nginx.conf /var/sitesconf

#creating the real nginx reverse proxy container, mapped to our config file
docker run --name nginx --link sonarqube:sonarqube -v ./var/sitesconf/nginx.conf:/etc/nginx/nginx.conf:ro -v /etc/ssl/certs/$hostname.crt:/etc/ssl/certs/$hostname.crt -v /etc/ssl/private/$hostname.key:/etc/ssl/private/$hostname.key -d -p 443:443 -p 80:80 --restart=always nginx

#blocking admin ports for security reasons
sudo ufw deny 9000
sudo ufw deny 9002
sudo ufw reload
