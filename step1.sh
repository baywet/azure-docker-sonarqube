dbusername=admin@server
dbpwd=Pwd
sqlserver=server.database.windows.net
databasename=dbname
hostname=machinefqdn
connectionString="jdbc:sqlserver://$sqlserver;databaseName=$databasename;"
organization=companyname
ounit=division
country=twocharacterscountrycode
location=cityname
state=state
email=email@domain.com

sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 9000
sudo ufw allow 9002
sudo systemctl start ufw
sudo systemctl enable ufw


docker run -d --name sonarqube -p 9000:9000 -p 9002:9002 -e SONARQUBE_JDBC_USERNAME=$dbusername -e SONARQUBE_JDBC_PASSWORD=$dbpwd -e SONARQUBE_JDBC_URL=$connectionString  --restart=always sonarqube

sudo openssl req -new -nodes -subj "/C=$country/ST=$state/L=$location/O=$organization/OU=$ounit/CN=$hostname/emailAddress=$email" > $hostname.crt
mv privkey.pem $hostname.pem
sudo openssl rsa -in $hostname.pem -out $hostname.key
sudo openssl x509 -in $hostname.crt -out $hostname.cert.cert -req -signkey $hostname.key -days 365
sudo cp $hostname.cert.cert /etc/ssl/certs/$hostname.crt
sudo cp $hostname.key /etc/ssl/private/$hostname.key

docker run --name nginx -d nginx
docker cp nginx:/etc/nginx/conf.d/default.conf /var/sitesconf
docker stop nginx
docker rm nginx

docker run --name nginx --link sonarqube:sonarqube -v /var/sitesconf:/etc/nginx/conf.d/default.conf:ro -v /etc/ssl/certs/$hostname.crt:/etc/ssl/certs/$hostname.crt -v /etc/ssl/private/$hostname.key:/etc/ssl/private/$hostname.key -d -p 443:443 -p 80:80 --restart=always nginx

sudo sed -i "s/\(listen\s*80;\)/\1\n\tlisten 443 ssl;\n\tlisten [::]:443 ssl;\n\tclient_max_body_size 64M;\n\tssl_certificate \/etc\/ssl\/certs\/$hostname.crt;\n\tssl_certificate_key \/etc\/ssl\/private\/$hostname.key;/" /var/sitesconf
sudo sed -i "s/server_name\s*localhost;/server_name  $hostname;/" /var/sitesconf
sudo sed -i '15d;17,48d' /var/sitesconf
sqip=$(docker inspect sonarqube | grep IPAddress | sed '1d;3d;' | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
sudo sed -i "s/root.*;/proxy_pass http:\/\/$sqip:9000;\n\tproxy_set_header X-Real-IP \$remote_addr;\n\tproxy_set_header X-Forwarded-For \$remote_addr;\n\tproxy_set_header Host \$host;/" /var/sitesconf
docker stop nginx
docker start nginx

sudo ufw deny 9000
sudo ufw deny 9002
sudo ufw reload
