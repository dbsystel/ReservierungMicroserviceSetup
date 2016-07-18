ADVERTISE_ADDRESS=`ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`

sudo docker run -d -p 4000:4000 --net=reservierung swarm manage -H :4000 --replication --advertise $ADVERTISE_ADDRESS:4000 consul://$1:8500
