sudo apt-get update -y --force-yes
sudo apt-get install apt-transport-https ca-certificates -y --force-yes
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo touch /etc/apt/sources.list.d/docker.list
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee -a /etc/apt/sources.list.d/docker.list
sudo apt-get update -y --force-yes
sudo apt-get purge lxc-docker
apt-cache policy docker-engine
sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual -y --force-yes
sudo apt-get install docker-engine -y --force-yes
sudo service docker start
sudo systemctl enable docker
sudo sed -i 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw
sudo usermod -aG docker $USER
echo "DOCKER FAST INSTALL DONE, DONT FORGET TO LOGOUT AND IN AGAIN"