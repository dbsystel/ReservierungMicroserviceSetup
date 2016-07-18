sudo rm /etc/docker/key.json
sudo mv /etc/default/docker docker
sudo chmod 777 docker
sudo echo "DOCKER_OPTS=\"-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --cluster-advertise eth0:2375 --cluster-store etcd://$1:2379\"" >> docker
sudo mv docker /etc/default/docker
sudo service docker restart
