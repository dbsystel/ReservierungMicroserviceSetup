sudo docker network create --driver=overlay --subnet=10.0.0.0/16  reservierung

sudo docker run -d  -p 8500:8500  --name=consul --net=reservierung progrium/consul -server -bootstrap
