sudo docker stop $(sudo docker ps -aq)
sudo docker rm -v $(sudo docker ps -aq)

sudo docker pull bachelorproject/msi

ADVERTISE_ADDRESS=`ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`

sudo docker run -d --net=reservierung swarm join --advertise $ADVERTISE_ADDRESS:2375 consul://$1:8500